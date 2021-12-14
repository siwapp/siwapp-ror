class CategoriesController < ApplicationController
  # GET method to get all categorys from database   
  def index   
    @categories = Category.all.paginate(page: params[:page], per_page: 20)
  end   
   
  # GET method to get a category by id   
  def show   
    @category = Category.find(params[:id])   
  end   
   
  # GET method for the new category form   
  def new   
    @category = Category.new   
  end   
   
  # POST method for processing form data   
  def create   
    @category = Category.new(category_params)   
    if @category.save   
      flash[:notice] = 'Category added!'   
      redirect_to categories_path
    else   
      flash[:error] = 'Failed to edit category!'   
      render :new   
    end   
  end   
   
   # GET method for editing a category based on id   
  def edit   
    @category = Category.find(params[:id])   
  end   
   
  # PUT method for updating in database a category based on id   
  def update   
    @category = Category.find(params[:id])   
    if @category.update_attributes(category_params)   
      flash[:notice] = 'Category updated!'   
      redirect_to categories_path
    else   
      flash[:error] = 'Failed to edit category!'   
      render :edit   
    end   
  end   
   
  # DELETE method for deleting a category from database based on id   
  def destroy   
    @category = Category.find(params[:id])
    @inventory_count = Inventory.where(category_id: @category.id).count
    if @inventory_count <= 0 && @category.delete
      flash[:notice] = 'Category deleted!'
      redirect_to categories_path
    else   
      flash[:error] = 'Failed to delete this category!'   
      redirect_to categories_path   
    end   
  end

  # we used strong parameters for the validation of params   
  def category_params   
    params.require(:category).permit(:name)   
  end
end
