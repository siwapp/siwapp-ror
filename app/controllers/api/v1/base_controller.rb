class Api::V1::BaseController < ApplicationController

#  force_ssl unless: proc { Rails.env.development? || Rails.env.testing? }
  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from Exception, with: :render_error # any error? go to handler!

  def default_url_options(options = {})
    options
  end

  protected

  # handle errors
  def render_error exception
    case exception.class.name
    when 'ActiveRecord::RecordNotFound' then
      error_info = { error: 'Resource Not Found' }
      status = 404
    else
      error_info = {
        error: 'Oops!! Internal Server Error',
        exception: "#{exception.class.name} : #{exception.message}"
      }
      error_info[:trace] = exception.backtrace[0,10] if Rails.env.development?
      status = 500
    end
    render json: error_info, status: status
  end

  # add pagination headers
  # see http://www.metabates.com/2012/02/22/adding-pagination-to-an-api/
  def self.set_pagination_headers(name, options = {})
    after_action(options) do |controller|
      results = instance_variable_get("@#{name}")
      headers["X-Pagination"] = {
        total: results.total_entries,
        total_pages: results.total_pages,
        first_page: results.current_page == 1,
        last_page: results.next_page.blank?,
        previous_page: results.previous_page,
        next_page: results.next_page,
        out_of_bounds: results.out_of_bounds?,
        offset: results.offset
      }.to_json
    end
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end


  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      if !token.nil? and token == Settings.api_token
        User.first
      end
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end

end
