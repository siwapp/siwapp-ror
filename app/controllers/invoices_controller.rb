class InvoicesController < CommonsController

  def show
    # Shows the template in an iframe
    if @invoice.get_status != :paid
      # Redirect to edit if invoice not closed
      redirect_to action: :edit
    else
      render
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    # put an empty item
    @invoice.items << Item.new(common: @invoice, taxes: Tax.default)
    render
  end

  # GET /invoices/autocomplete.json
  # View to get the item autocomplete feature.
  def autocomplete
    @items = Item.autocomplete_by_description(params[:term])
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
    begin
      @invoice.send_email
      redirect_back(fallback_location: root_path, notice: 'Email successfully sent.')
    rescue Exception => e
      redirect_back(fallback_location: root_path, alert: e.message)
    end
  end

  # Renders a common's template in html and pdf formats
  def print
    @invoice = Invoice.find(params[:id])
    html = render_to_string :inline => @invoice.get_print_template.template,
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
        total = invoices.inject(0) do |n, inv|
          inv.set_paid! ? n + 1 : n
        end
        flash[:info] = "Successfully set as paid #{total} invoices."
      when 'pdf'
        html = ''
        invoices.each do |inv|
          @invoice = inv
          html += render_to_string \
              :inline => inv.get_print_template.template,
              :locals => {:invoice => @invoice,
                          :settings => Settings}
          html += '<div class="page-break" style="page-break-after:always;"></div>'
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
    common_params + [
      :number,
      :issue_date,
      :due_date,

      :email_template_id,
      :print_template_id,

      :failed,

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
