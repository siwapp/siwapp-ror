class Api::V1::MetaAttributesController < Api::V1::BaseController

  include MetaAttributes

  before_action :set_invoice

  # GET /api/v1/invoices/:invoice_id/meta_attributes
  def index
    render json: {'data': @invoice.meta}
  end

  # PUT /api/v1/invoices/:invoice_id/meta_attributes/id
  # can overwrite
  # <id> is the attribute key
  def update
    meta_attribute_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
    @invoice.set_meta(params[:id], meta_attribute_params[:value])
    render json: {'data': { params[:id] => @invoice.get_meta(params[:id])}}
  end

  # DELETE /api/v1/invoices/:invoice_id/meta_attributes/id
  # <id> is the attribute key
  def destroy
    @invoice.delete_meta params[:id]
    render json: { message: "Meta Attribute deleted" }, status: :no_content
  end


  private

  def set_invoice
    @invoice = Invoice.find params[:invoice_id]
  end

end
