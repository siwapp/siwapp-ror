class SettingsController < ApplicationController
  # Global configuration settings
  def global
    if request.post?  # save values posted
      [:company_name, :company_vat_id, :company_address, :company_phone,
          :company_email, :company_url, :company_logo,
          :legal_terms]
      .each do |key|
        Settings[key] = params[key]
            

      # save currency
      Settings.currency = params[:currency][:id]
      end
    end
    @company_name = Settings.company_name
    @company_vat_id = Settings.company_vat_id
    @company_address = Settings.company_address
    @company_phone = Settings.company_phone
    @company_email = Settings.company_email
    # This must be an url because there is no way of uploading files to
    # heroku. One option would be to use S3, but it's not worth it.
    @company_url = Settings.company_url
    @company_logo = Settings.company_logo
    # currency select
    currency_id = Settings.currency || :eur
    @currency = Money::Currency.find currency_id
    @currencies = Money::Currency.all
    @legal_terms = Settings.legal_terms
  
  end

  def my_configuration
    # TODO: This is still pretty lame. Validation errors should be shown into
    #       the form.
    @user = current_user
    if request.post?
      @user.update_attribute(:name, params[:user][:name])
      @user.update_attribute(:email, params[:user][:email])
      if params[:new_password] \
          and params[:new_password] == params[:new_password2] \
          and @user.authenticate(params[:old_password])
        @user.password = params[:new_password]
        @user.validate!
        @user.save!
      end
    end

  end
end
