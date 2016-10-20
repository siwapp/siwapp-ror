require 'csv'

class InvoicesController < CommonsController

  def show
    # Show the template in an iframe
    respond_to do |format|
      format.json { render json: @invoice }
      format.html do
        # Redirect to edit if invoice not closed
        if @invoice.get_status != :paid or not get_print_template
          redirect_to action: :edit
        end
        format.html
      end
    end
  end

  def edit
    @templates = Template.all
    get_print_template
    render
  end

  # GET /invoices/autocomplete.json
  # View to get the item autocomplete feature.
  def autocomplete
    @items = Item.unique_description("%#{params[:term]}%")
    respond_to do |format|
      format.json
    end
  end

  # GET /invoices/chart_data.json
  # Returns a json with dates as keys and sums of the invoices
  # as values. Uses the same parameters as search.
  def chart_data
    date_from = (params[:q].nil? or params[:q][:issue_date_gteq].empty?) ? 30.days.ago.to_date : Date.parse(params[:q][:issue_date_gteq])
    date_to = (params[:q].nil? or params[:q][:issue_date_lteq].empty?) ? Date.current : Date.parse(params[:q][:issue_date_lteq])

    scope = @search.result.where(draft: false, failed: false).\
      where("issue_date >= :date_from AND issue_date <= :date_to",
            {date_from: date_from, date_to: date_to})
    scope = scope.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    scope = scope.select('issue_date, sum(gross_amount) as total').group('issue_date')

    # build all keys with 0 values for all
    @date_totals = {}

    (date_from..date_to).each do |day|
      @date_totals[day.to_formatted_s(:db)] = 0
    end

    scope.each do |inv|
      @date_totals[inv.issue_date.to_formatted_s(:db)] = inv.total
    end

    render
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    if params && params[:common] && params[:common][:email_template_id]
      @invoice.email_template = Template.find(params[:common][:email_template_id])
      @invoice.save
    end
    begin
      @invoice.send_email
      redirect_to :back, notice: "Email successfully sent."
    rescue Exception => e
      redirect_to :back, alert: e.message
    end
  end

  # Bulk actions for the invoices listing
  def bulk
    ids = params["#{model.name.underscore}_ids"]
    if ids.is_a?(Array) && ids.length > 0
      invoices = Invoice.where(id: params["#{model.name.underscore}_ids"])
      case params['bulk_action']
      when 'delete'
        invoices.destroy_all
        flash[:info] = "Successfully deleted #{ids.length} invoices."
      when 'send_email'
        begin
          invoices.each {|inv| inv.send_email}
          flash[:info] = "Successfully sent #{ids.length} emails."
        rescue Exception => e
          flash[:alert] = e.message
        end
      when 'set_paid'
        invoices.each {|inv| inv.set_paid}
        flash[:info] = "Successfully set as paid #{ids.length} invoices."
      when 'pdf'
        html = ''
        invoices.each do |inv|
          @invoice = inv
          html += render_to_string :inline => inv.get_print_template.template,
            :locals => {:invoice => @invoice, :settings => Settings}
        end
        send_data(@invoice.pdf(html),
          :filename => "invoices.pdf",
          :disposition => 'attachment'
        )
        return
      else
        flash[:info] = "Unknown action."
      end
    end
    redirect_to action: :index
  end

  def get_csv(invoices=Invoice.all)
    meta_attributes_keys = invoices.meta_attributes_keys
    csv_string = CSV.generate do |csv|
      csv << ["id", "series", "customer_id", "name", "identification", "email",
          "invoicing_address", "shipping_address", "contact_person", "terms",
          "notes", "base_amount", "discount_amount", "net_amount",
          "gross_amount", "paid_amount", "tax_amount", "draft", "paid",
          "sent_by_email", "number", "recurring_invoice_id", "issue_date",
          "due_date", "created_at", "updated_at", "print_template_id", "failed"] +
          meta_attributes_keys  # add all the meta_attributes keys
      invoices.each do |i|
        meta_attributes_values = meta_attributes_keys.map do |key|
          i.meta[key]
        end
        csv << [i.id, i.series, i.customer_id, i.name, i.identification, i.email,
            i.invoicing_address, i.shipping_address, i.contact_person, i.terms,
            i.notes, i.base_amount, i.discount_amount, i.net_amount,
            i.gross_amount, i.paid_amount, i.tax_amount, i.draft, i.paid,
            i.sent_by_email, i.number, i.recurring_invoice_id, i.issue_date,
            i.due_date, i.created_at, i.updated_at, i.print_template_id, i.failed] +
            meta_attributes_values
      end
    end
  end

  protected

  def configure_search
    super
    @search_filters = true
  end

  def set_listing(instances)
    @invoices = instances
  end

  def set_instance(instance)
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def invoice_params
    [
      :number,
      :series_id,
      :issue_date,
      :due_date,
      :days_to_due,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,
      :terms,
      :notes,

      :draft,
      :failed,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],

      payments_attributes: [
        :id,
        :date,
        :amount,
        :notes,
        :_destroy
      ],

      tag_list: []
    ]
  end
end
