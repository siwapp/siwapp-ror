class Api::V1::TaxesController < Api::V1::BaseController
  before_action :set_type
  before_action :set_tax, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/taxes
  # GET /api/v1/items/:item_id/taxes
  def index
    @taxes = params['item_id'] ? Item.find(params['item_id']).taxes : Tax.all
    render json: @taxes
  end

  # GET /api/v1/taxes/1
  def show
    @tax = Tax.find params[:id]
    render json: @tax
  end

  # POST /api/v1/taxes
  def create
    @tax = Tax.new(tax_params)
    if @tax.save
      render json: @tax, status: :created, location: api_v1_tax_url(@tax) 
    else
      render json: @tax.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/taxes/1
  def update
    
    if @tax.update(tax_params)
      render json: @tax, status: :ok, location: api_v1_tax_url(@tax) 
    else
      render json: @tax.errors, status: :unprocessable_entity 
    end
    
  end

  # DELETE /api/v1/taxes/1
  def destroy
    @tax.destroy
    render json: { message: "Content deleted" }, status: :no_content
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_params
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
    end
end
