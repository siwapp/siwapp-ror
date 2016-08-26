class InvoicesController < CommonsController
  # Gets the template to display invoices
  def get_template
    if template = @invoice.template or template = Template.find_by(default: true)
      @template_url = "/invoices/template/#{template.id}/invoice/#{@invoice.id}"
    else
      @template_url = ""
    end
  end

  def show
    # Show the template in an iframe
    respond_to do |format|
      format.json { render json: @invoice }
      format.html do
        # Redirect to edit if invoice not closed
        if @invoice.get_status != :paid or not get_template
          redirect_to action: :edit
        end
        format.html
      end
    end
  end

  def edit
    @legal_terms = Settings.legal_terms
    @templates = Template.all
    get_template
    render
  end

  # Renders an invoice template in html and pdf formats
  def template
    @invoice = Invoice.find(params[:invoice_id])
    @template = Template.find(params[:id])
    html = render_to_string :inline => @template.template,
      :locals => {:invoice => @invoice, :settings => Settings}
    respond_to do |format|
      format.html { render inline: html }
      format.pdf do
        pdf = @invoice.pdf(html)
        send_data(pdf,
          :filename    => "#{@invoice}.pdf",
          :disposition => 'attachment'
        )
      end
    end
  end

  def select_template
    redirect_to action: "template", invoice_id: params[:id], id: params[:invoice][:template_id]
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
    date_to = (params[:q].nil? or params[:q][:issue_date_lteq].empty?) ? Date.today : Date.parse(params[:q][:issue_date_lteq])

    scope = @search.result(distinct: true)
    scope = scope.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    scope = scope.select('issue_date, sum(gross_amount) as total').where(draft: false).group('issue_date')

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
    @invoice.send_email
    redirect_to :back, notice: "Email successfully sent."
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
        invoices.each {|inv| inv.send_email}
        flash[:info] = "Successfully sent #{ids.length} emails."
      when 'set_paid'
        invoices.each {|inv| inv.set_paid}
        flash[:info] = "Successfully set as paid #{ids.length} invoices."
      when 'pdf'
        html = ''
        invoices.each do |inv|
          @invoice = inv
          html += render_to_string :inline => inv.get_template.template,
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

      :tag_list,

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
      ] 
      
    ]
  end
end
