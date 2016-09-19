class DashboardController < ApplicationController
  def index
    @objects = Invoice.with_status(:past_due).paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render :index, layout: 'infinite-scrolling' }
    end
  end
end
