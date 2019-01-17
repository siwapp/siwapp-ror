class Api::V1::InvoicesController < Api::V1::CommonsController

  set_pagination_headers :invoices, only: [:index]

  # Renders invoice template in pdf
  # GET /api/v1/invoices/template/:id/invoice/:invoice_id
  def template
    @invoice = Invoice.find(params[:invoice_id])
    @template = Template.find(params[:id])
    html = render_to_string :inline => @template.template,
      :locals => {invoice: @invoice, settings: Settings}
    respond_to do |format|
      format.pdf do
        pdf = @invoice.pdf(html)
        send_data(pdf, :filename => "#{@invoice}.pdf", :disposition => 'attachment')
      end
    end
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    if params && params[:template_id]
      @invoice.email_template = Template.find(params[:template_id])
      @invoice.save
    end
    begin
      @invoice.send_email
      render json: {"message": "E-mail succesfully sent."}, status: :ok

    rescue Exception => e
      render json: {"message": e.message}, status: :error
    end
  end

  def stats
    date_from = (params[:q].nil? or params[:q][:issue_date_gteq].nil?) ? Date.current.beginning_of_year : Date.parse(params[:q][:issue_date_gteq])
    date_to = (params[:q].nil? or params[:q][:issue_date_lteq].nil?) ? Date.current : Date.parse(params[:q][:issue_date_lteq])
    currency = (params[:q].nil? or params[:q][:currency].nil?) ? '' : params[:q][:currency].downcase

    scope = Invoice.where(draft: false, failed: false).\
      where("issue_date >= :date_from AND issue_date <= :date_to",
            {date_from: date_from, date_to: date_to})
    scope = scope.where("currency like :currency", {currency: currency}) if !currency.empty?
    scope = scope.select("to_char(issue_date, 'YYYY-MM') as date, currency, sum(gross_amount) as total, count(id) as count").group('date, currency')
    scope = scope.order("date")

    # build all keys
    @date_totals = Hash.new({})

    scope.each do |inv|
      value = {inv.currency.downcase => {"total" => inv.total, "count" => inv.count}}
      @date_totals[inv.date] = @date_totals[inv.date].merge(value)
    end

    render json: @date_totals, status: :ok
  end

  protected

  def set_instance instance
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def set_listing instances
    @invoices = instances
    render json: @invoices
  end

  def invoice_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
  end
end
