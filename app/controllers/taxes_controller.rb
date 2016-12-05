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
      else
        flash[:alert] = "Tax has not been created."
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /taxes/1
  # PATCH/PUT /taxes/1.json
  def update
    respond_to do |format|
      if @tax.update(tax_params)
        format.html { redirect_to taxes_url, notice: 'Tax was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /taxes/1
  # DELETE /taxes/1.json
  def destroy
    respond_to do |format|
      if @tax.destroy
        format.html { redirect_to taxes_url, notice: 'Tax was successfully deleted.' }
      else
        flash[:alert] = @tax.errors.full_messages.join(" ")
        format.html { redirect_to edit_tax_path(@tax) }
      end
    end
  end

  def set_default
    selected = params["default_tax"]
    selected_taxes = Tax.find(id=selected)
    unselected_taxes = Tax.where("id not in (?)", selected)
    selected_taxes.each do |selected_tax|
      selected_tax.default = true
      selected_tax.save
    end
    unselected_taxes.each do |unselected_tax|
      unselected_tax.default = false
      unselected_tax.save
    end

    redirect_to(:action => 'index')
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
