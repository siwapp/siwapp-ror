class SettingsController < ApplicationController

  force_ssl only: [:api_token], unless: :is_development

  # Global configuration settings
  def global
    @global_settings = GlobalSettings.new
  end

  def global_update
    @global_settings = GlobalSettings.new global_settings_params
    if @global_settings.save_settings
      redirect_to settings_global_path, {notice: "Global settings successfully saved"}
    else
      flash.now[:alert] = "Global settings could not be saved"
      render 'settings/global'
    end
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

  # Hooks settings
  def hooks
    if request.post?
      Settings[:event_invoice_generation_url] = params[:event_invoice_generation_url]
      redirect_to action: :hooks
    end

    # log count
    total_logs = WebhookLog.order(created_at: :desc).where(event: :invoice_generation).count
    # pagination math
    if total_logs < 20
      num_pages = 1
    else
      num_pages = total_logs / 20 + ( total_logs % 20 == 0 ? 0 : 1)
    end
    # pagination parameters
    page = (params.has_key?(:page) and Integer(params[:page]) >= 1) ? Integer(params[:page]) : 1

    # fetch paged logs
    @paged_logs = WebhookLog.order(created_at: :desc).limit(20).offset((page-1)*20).where event: :invoice_generation

    #pagination info
    @previous_page = page > 1 ? page - 1 : nil
    @next_page = page < num_pages ? page + 1 : nil

    @event_invoice_generation_url = Settings.event_invoice_generation_url
  end


  # API Token show/generation
  def api_token
    if request.post?
      Settings[:api_token] = SecureRandom.uuid.gsub(/\-/,'')
      redirect_to action: :api_token
    end
    @api_token = Settings.api_token
  end



  private

  def is_development
    Rails.env.development?
  end

  def global_settings_params
    params.require(:global_settings).permit(:company_name, :company_vat_id, :company_address, :company_phone, :company_email, :company_url, :company_logo, :currency, :legal_terms, :days_to_due)
  end




end
