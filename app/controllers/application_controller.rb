class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :login_required
  include SessionsHelper

  private
    def login_required
      unless :current_user
        flash[:error] = "You must be logged in to access this section"
        redirect_to login_url # halts request cycle
      end
    end

end
