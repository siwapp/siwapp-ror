class DashboardController < ApplicationController
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  def index
    @objects = Invoice.with_status(:past_due).order(:issue_date).paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html {render :index, layout: 'infinite-scrolling'}
    end
  end
end
