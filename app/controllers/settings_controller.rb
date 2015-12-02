class SettingsController < ApplicationController
  # Global configuration settings
  def global
    if request.post?
      [:company_name, :company_address, :company_phone,
          :company_email, :company_url, :company_logo,
          :currency, :legal_terms]
      .each do |key|
        (Property.find_by key: key)
            .update(value: params[key])
      end
    end
    @company_name = (Property.find_by key: 'company_name').value
    @company_address = (Property.find_by key: 'company_address').value
    @company_phone = (Property.find_by key: 'company_phone').value
    @company_email = (Property.find_by key: 'company_email').value
    # This must be an url because there is no way of uploading files to
    # heroku. One option would be to use S3, but it's not worth of it.
    @company_url = (Property.find_by key: 'company_url').value
    @company_logo = (Property.find_by key: 'company_logo').value
    @currency = (Property.find_by key: 'currency').value
    @legal_terms = (Property.find_by key: 'legal_terms').value
  end

  def my_configuration
    @user = current_user
    if request.post?
      @user.update_attribute(:name, params[:user][:name])
      @user.update_attribute(:email, params[:user][:email])
      if params[:new_password] and params[:new_password] == params[:new_password2]
        @user.password = params[:new_password]
        @user.validate!
        @user.save!
      end
    end

  end
end
