class Api::V1::ItemsController < Api::V1::BaseController

  # GET /api/v1/invoices/:common_id/items
  def index
    common_id = params[:invoice_id] || params[:recurring_invoice_id]
    @items = Common.find(common_id).items
    render json: @items
  end

  # GET /api/v1/items/:id
  def show
    @item = Item.find params[:id]
    render json: @item
  end

  # POST /api/v1/invoices/:invoice_id/items
  def create
    @item = Item.new(item_params)
    @item.update common_id: params[:invoice_id] || params[:recurring_invoice_id]
    # alternative taxes format
    add_human_taxes @item, params
    if @item.save
      render json: @item, status: :created, location: api_v1_item_url(@item)
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  # PATH/PUTH /api/v1/items/:id
  def update
    @item = Item.find params[:id]
    if @item.update(item_params)
      add_human_taxes @item, params
      add_id_taxes @item, params
      render json: @item, status: :ok, location: api_v1_item_url(@item)
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/items/:id
  def destroy
    item = Item.find_by_id params[:id]
    if item
        item.destroy
    end
    render json: { message: "Content deleted" }, status: :no_content
  end

  private
  def item_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
  end

  # check if there's a 'taxes' array with taxes names and adds them to item
  def add_id_taxes item, params
    if params.has_key? :data and params[:data].has_key? :attributes and 
      params[:data][:attributes].has_key? :tax_ids
      
      params[:data][:attributes][:tax_ids].each do |tax_id|
        tax = Tax.find_by_id tax_id
        if tax and !item.taxes.exists? tax.id
          item.taxes<< tax
        end
      end
    end
  end

  # check if there's a 'taxes' array with taxes names and adds them to item
  def add_human_taxes item, params
    if params.has_key?(:data) and params[:data].has_key?(:attributes) and 
      params[:data][:attributes].has_key?(:taxes)

      params[:data][:attributes][:taxes].each do |tax_name|
        tax = Tax.find_by_name tax_name
        puts tax
        if tax and !item.taxes.exists? tax.id
          item.taxes << tax
        end
      end
    end
  end

end
