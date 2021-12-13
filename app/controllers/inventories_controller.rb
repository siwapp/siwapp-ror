class InventoriesController < ApplicationController

  def index   
    @inventories = Inventory.all.paginate(page: params[:page], per_page: 20)
  end   
   
  # GET method to get a Inventory by id   
  def show   
    @inventory = Inventory.find(params[:id])   
  end   
   
  # GET method for the new Inventory form   
  def new   
    @inventory = Inventory.new   
  end   
   
  # POST method for processing form data   
  def create   
    @inventory = Inventory.new(inventory_params)   
    if @inventory.save   
      flash[:notice] = 'Inventory added!'   
      redirect_to inventories_path
    else   
      flash[:error] = 'Failed to edit Inventory!'   
      render :new   
    end   
  end   
   
   # GET method for editing a Inventory based on id   
  def edit   
    @inventory = Inventory.find(params[:id])   
  end   
   
  # PUT method for updating in database a Inventory based on id   
  def update   
    @inventory = Inventory.find(params[:id])   
    if @inventory.update_attributes(inventory_params)   
      flash[:notice] = 'Inventory updated!'   
      redirect_to inventories_path
    else
      flash[:error] = 'Failed to edit Inventory!'   
      render :edit   
    end   
  end

  def update_inventory
    @inventories = Inventory.where("category_id = ?", params[:category_id])
    @select_id = params[:select_id]
    puts "============#{@select_id}"
    respond_to do |format|
      format.js
    end
  end
   
  # DELETE method for deleting a Inventory from database based on id   
  def destroy   
    @inventory = Inventory.find(params[:id])   
    if @category.delete   
      flash[:notice] = 'Inventory deleted!'
      redirect_to categories_path
    else   
      flash[:error] = 'Failed to delete this Inventory!'   
      render :destroy   
    end   
  end

  # we used strong parameters for the validation of params   
  def inventory_params   
    params.require(:inventory).permit(:name, :price, :category_id)   
  end
end
