class UsersController < ApplicationController
  before_action :logged_in?

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
  	@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:info] = 'User updated correctly'
      redirect_to invoices_url
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    

end
