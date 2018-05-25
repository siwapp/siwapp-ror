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
