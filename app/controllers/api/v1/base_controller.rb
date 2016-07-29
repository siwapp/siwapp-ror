class Api::V1::BaseController < ApplicationController

  force_ssl unless: proc { Rails.env.development?}

  protect_from_forgery with: :null_session

  before_action :destroy_session

#  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  protected

  def self.set_pagination_headers(name, options = {})
    after_filter(options) do |controller|
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
      if !token.nil? and token == Settings[:api_token]
        User.first
      end
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end

end
