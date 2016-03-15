class TaxGroupsController < ApplicationController
  # GET /series
  # GET /series.json
  def index
    @tax_groups = Series.all
  end

  # GET /taxes/1
  # GET /taxes/1.json
  def show
  end

  # GET /taxes/new
  def new
    @tax_group = TaxGroup.new
  end

  # GET /taxes/1/edit
  def edit
  end

  # POST /taxes
  # POST /taxes.json
  def create
    @tax_group = TaxGroup.new(tax_group_params)

    respond_to do |format|
      if @tax_group.save
        format.html { redirect_to tax_groups_url, notice: 'Tax group was successfully created.' }
        format.json { render :show, status: :created, location: @tax_group }
      else
        flash[:alert] = "Tax group has not been created."
        format.html { render :new }
        format.json { render json: @tax_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taxes/1
  # PATCH/PUT /taxes/1.json
  def update
    respond_to do |format|
      if @tax.update(tax_params)
        format.html { redirect_to tax_groups_url, notice: 'Tax group was successfully updated.' }
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
      format.html { redirect_to tax_groups_url, notice: 'Tax was successfully destroyed.' }
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
