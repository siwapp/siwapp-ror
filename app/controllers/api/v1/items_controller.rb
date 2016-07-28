class Api::V1::ItemsController < Api::V1::BaseController

  # GET /api/v1/invoices/:common_id/items
  def index
    common_id = params[:invoice_id] || params[:recurring_invoice_id]
    @items = Common.find(common_id).items
  end

  # GET /api/v1/items/:id
  def show
    @item = Item.find params[:id]
  end

  # POST /api/v1/invoices/:invoice_id/items
  def create
    @item = Item.new(item_params)
    @item.update common_id: params[:invoice_id] || params[:recurring_invoice_id]
    # alternative taxes format
    add_human_taxes @item, params
    respond_to do |format|
      if @item.save
        format.json { redirect_to api_v1_item_url(@item) }
       else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATH/PUTH /api/v1/items/:id
  def update
    respond_to do |format|
      @item = Item.find params[:id]
      if @item.update(item_params)
        add_human_taxes @item, params
        format.json { render action: 'show', status: :ok, location: api_v1_item_url(@item) }
      else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def item_params
    params.require(:item).permit(:description, :quantity, :unitary_cost, :discount, {:tax_ids => []})
  end

  # check if there's a 'taxes' array with taxes names and adds them to item
  def add_human_taxes item, params
    if params.has_key? :item and params[:item].has_key? :taxes
      params[:item][:taxes].each do |tax_name|
        tax = Tax.find_by_name tax_name
        if tax and !item.taxes.exists? tax.id
          item.taxes<< tax
        end
      end
    end
  end

end
