class TaxesController < ApplicationController
  before_action :set_type
  before_action :set_tax, only: [:show, :edit, :update, :destroy]

  # GET /taxes
  # GET /taxes.json
  def index
    @taxes = Tax.all
  end

  # GET /taxes/1
  # GET /taxes/1.json
  def show
  end

  # GET /taxes/new
  def new
    @tax = Tax.new
  end

  # GET /taxes/1/edit
  def edit
  end

  # POST /taxes
  # POST /taxes.json
  def create
    @tax = Tax.new(tax_params)

    respond_to do |format|
      if @tax.save
        format.html { redirect_to taxes_url, notice: 'Tax was successfully created.' }
        format.json { render :show, status: :created, location: @tax }
      else
        flash[:alert] = "Tax has not been created."
        format.html { render :new }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taxes/1
  # PATCH/PUT /taxes/1.json
  def update
    respond_to do |format|
      if @tax.update(tax_params)
        format.html { redirect_to taxes_url, notice: 'Tax was successfully updated.' }
        format.json { render :show, status: :ok, location: @tax }
      else
        format.html { render :edit }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxes/1
  # DELETE /taxes/1.json
  def destroy
    @tax.destroy
    respond_to do |format|
      format.html { redirect_to taxes_url, notice: 'Tax was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_params
      params.require(:tax).permit(:name, :value, :active, :is_default)
    end
end
