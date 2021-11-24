class Api::V1::ServicesController < Api::V1::BaseController
  before_action :set_type
  before_action :set_services, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/services
  # GET /api/v1/items/:item_id/services
  def index
    @services = params['item_id'] ? Item.find(params['item_id']).services : Service.all
    render json: @services
  end

  # GET /api/v1/services/1
  def show
    @services = Service.find params[:id]
    render json: @services
  end

  # POST /api/v1/services
  def create
    @services = Service.new(services_params)
    if @services.save
      render json: @services, status: :created, location: api_v1_services_url(@services) 
    else
      render json: @services.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/services/1
  def update
    
    if @services.update(services_params)
      render json: @services, status: :ok, location: api_v1_services_url(@services) 
    else
      render json: @services.errors, status: :unprocessable_entity 
    end
    
  end

  # DELETE /api/v1/services/1
  def destroy
    @services.destroy
    render json: { message: "Content deleted" }, status: :no_content
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_services
      @services = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def services_params
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
    end
end
