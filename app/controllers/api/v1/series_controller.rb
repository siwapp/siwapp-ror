class Api::V1::SeriesController < Api::V1::BaseController
  before_action :set_type
  before_action :set_series, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/series
  def index
    @series = Series.all  
    render json: @series
  end

  # GET /api/v1/series/1
  def show
    @series = Series.find params[:id]
    render json: @series
  end

  # POST /api/v1/series
  def create
    @series = Series.new(series_params)
    if @series.save
      render json: @series, status: :created, location: api_v1_series_url(@series) 
    else
      render json: {errors: @series.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/series/1
  def update
    if @series.update(series_params)
      render json: @series, status: :ok, location: api_v1_series_url(@series) 
    else
      render json: {errors: @series.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/series/1
  def destroy
    @series.destroy
    render json: { message: "Content deleted" }, status: :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Series.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
    end
end
