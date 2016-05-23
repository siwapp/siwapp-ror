class SettingsController < ApplicationController
  # Global configuration settings
  def global
    if request.post?
      [:company_name, :company_vat_id, :company_address, :company_phone, :company_url, :legal_terms, :days_to_due, :company_email].each do |key|
        Settings[key] = params[key]
      end
      Settings.company_logo = params[:company_logo].gsub('https://', 'http://')
      Settings.currency = params[:currency][:id]
      redirect_to action: :global
    end

    @company_name = Settings.company_name
    @company_vat_id = Settings.company_vat_id
    @company_address = Settings.company_address
    @company_phone = Settings.company_phone
    # This must be an url because there is no way of uploading files to
    # heroku. One option would be to use S3, but it's not worth it.
    @company_url = Settings.company_url
    @company_logo = Settings.company_logo
    # currency select
    currency_id = Settings.currency
    @currency = Money::Currency.find currency_id
    @currencies = Money::Currency.all
    @legal_terms = Settings.legal_terms
    @days_to_due = Settings.days_to_due
    @company_email = Settings.company_email

  end

  def smtp
    if request.post?
      [:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject].each do |key|
        Settings[key] = params[key]
      end
      redirect_to action: :smtp
    end

    @host = Settings.host
    @port = Settings.port
    @domain = Settings.domain
    @user = Settings.user
    @password = Settings.password
    @authentication = Settings.authentication
    @enable_starttls_auto = Settings.enable_starttls_auto
    @email_body = Settings.email_body
    @email_subject = Settings.email_subject

  end

  def profile
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
      redirect_to action: :profile
    end

  end
end
