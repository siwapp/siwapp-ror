class SeriesController < ApplicationController
  before_action :set_type
  before_action :set_series, only: [:show, :edit, :update, :destroy]

  # GET /series
  # GET /series.json
  def index
    @series = Series.all
  end

  # GET /series/1
  # GET /series/1.json
  def show
    @series = Series.find params[:id]
  end

  # GET /series/new
  def new
    @series = Series.new
  end

  # GET /series/1/edit
  def edit
  end

  # POST /series
  # POST /series.json
  def create
    @series = Series.new(series_params)

    respond_to do |format|
      if @series.save
        format.html { redirect_to series_index_url, notice: 'Series was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /series/1
  # PATCH/PUT /series/1.json
  def update
    respond_to do |format|
      if @series.update(series_params)
        format.html { redirect_to series_index_url, notice: 'Series was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # POST /series
  # updates default series
  def set_default
    Series.where(id: params["default_series"]).update_all(default: true)
    Series.where.not(id: params["default_series"]).update_all(default: false)

    redirect_to(:action => 'index')
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    respond_to do |format|
      if @series.destroy
       format.html { redirect_to series_index_url, notice: 'Series was successfully destroyed.' }
	  else
	    flash[:alert] = "Series has invoices and can not be destroyed."
        format.html { redirect_to edit_series_path(@series) }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Series.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      params.require(:series).permit(:name, :value, :enabled, :first_number)
    end
end
