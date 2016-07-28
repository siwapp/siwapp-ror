class Api::V1::SeriesController < Api::V1::BaseController
  before_action :set_type
  before_action :set_series, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/series
  def index
    @series = Series.all
  end

  # GET /api/v1/series/1
  def show
    @series = Series.find params[:id]
  end

  # POST /api/v1/series
  def create
    @series = Series.new(series_params)

    respond_to do |format|
      if @series.save
        format.json { render :show, status: :created, location: @series }
      else
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/series/1
  def update
    respond_to do |format|
      if @series.update(series_params)
        format.json { render :show, status: :ok, location: @series }
      else
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/series/1
  def destroy
    @series.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Series.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      params.require(:series).permit(:name, :value, :enabled, :next_number)
    end
end
