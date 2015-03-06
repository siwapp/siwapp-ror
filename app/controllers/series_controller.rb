class SeriesController < ApplicationController
  before_action :set_serie, only: [:show, :edit, :update, :destroy]

  # GET /series
  # GET /series.json
  def index
    @series = Serie.all
  end

  # GET /series/1
  # GET /series/1.json
  def show
  end

  # GET /series/new
  def new
    @serie = Serie.new
  end

  # GET /series/1/edit
  def edit
  end

  # POST /series
  # POST /series.json
  def create
    @serie = Serie.new(serie_params)

    respond_to do |format|
      if @serie.save
        format.html { redirect_to @serie, notice: 'Serie was successfully created.' }
        format.json { render :show, status: :created, location: @serie }
      else
        format.html { render :new }
        format.json { render json: @serie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /series/1
  # PATCH/PUT /series/1.json
  def update
    respond_to do |format|
      if @serie.update(serie_params)
        format.html { redirect_to @serie, notice: 'Serie was successfully updated.' }
        format.json { render :show, status: :ok, location: @serie }
      else
        format.html { render :edit }
        format.json { render json: @serie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    @serie.destroy
    respond_to do |format|
      format.html { redirect_to series_url, notice: 'Serie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serie
      @serie = Serie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serie_params
      params.require(:serie).permit(:name, :value, :enabled, :next_number)
    end
end
