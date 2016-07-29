class Api::V1::TaxesController < Api::V1::BaseController
  before_action :set_type
  before_action :set_tax, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/taxes
  def index
    @taxes = Tax.all
  end

  # GET /api/v1/taxes/1
  def show
  end

  # POST /api/v1/taxes
  def create
    @tax = Tax.new(tax_params)

    respond_to do |format|
      if @tax.save
        format.json { render :show, status: :created, location: @tax }
      else
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/taxes/1
  def update
    respond_to do |format|
      if @tax.update(tax_params)
        format.json { render :show, status: :ok, location: @tax }
      else
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/taxes/1
  def destroy
    @tax.destroy
    respond_to do |format|
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
      params.require(:tax).permit(:name, :value, :active, :default)
    end
end
