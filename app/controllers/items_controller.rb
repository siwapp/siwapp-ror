class ItemsController < ApplicationController
  before_action :set_invoice
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def new
    @item = Item.new
  end

  def create
    @item = @invoice.items.build(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to [@invoice, @item], notice: 'Item was successfully created.'}
        format.json { render :show, satus: :created, location: [@invoice, @item]}
      else
        flash[:alert] = 'Item has not been created.'
        format.html { render :new}
        format.json { render json: @item.errors, status: :unprocessable_entity}    
      end
    end
  end

  def show
  end

  private
  def set_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:description, :quantity, :unitary_cost)
  end
end
