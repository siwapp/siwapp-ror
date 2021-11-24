class ServicesController < ApplicationController
    before_action :set_type
    before_action :set_service, only: [:show, :edit, :update, :destroy]
  
    # GET /services
    # GET /services.json
    def index
      @services = Service.all
    end
  
    # GET /services/new
    def new
      @service = Service.new
    end
  
    # POST /services
    # POST /services.json
    def create
      @service = Service.new(service_params)
  
      respond_to do |format|
        if @service.save
          format.html { redirect_to services_url, notice: 'service was successfully created.' }
        else
          flash[:alert] = "service has not been created."
          format.html { render :new }
        end
      end
    end
  
    # PATCH/PUT /services/1
    # PATCH/PUT /services/1.json
    def update
      respond_to do |format|
        if @service.update(service_params)
          format.html { redirect_to services_url, notice: 'service was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  
    # DELETE /services/1
    # DELETE /services/1.json
    def destroy
      respond_to do |format|
        if @service.destroy
          format.html { redirect_to services_url, notice: 'service was successfully deleted.' }
        else
          flash[:alert] = @service.errors.full_messages.join(" ")
          format.html { redirect_to edit_service_path(@service) }
        end
      end
    end
  
    def set_default
      Service.where(id: params["default_service"]).update_all(default: true)
      Service.where.not(id: params["default_service"]).update_all(default: false)
      redirect_to(:action => 'index')
    end
  
    def get_defaults
      render json: Service.where(active: true, default: true)
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_service
        @service = Service.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def service_params
        params.require(:service).permit(:name, :value, :active, :default)
      end
  end
  