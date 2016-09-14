class SettingsController < ApplicationController

  force_ssl only: [:api_token], unless: :is_development

  # GET /settings/global
  def global
    @global_settings = GlobalSettings.new
  end

  # PUT /settings/global
  def global_update
    @global_settings = GlobalSettings.new global_settings_params
    if @global_settings.save_settings
      redirect_to settings_global_path, notice: "Global settings successfully saved"
    else
      flash.now[:alert] = "Global settings could not be saved"
      render 'settings/global'
    end
  end

  # GET /settings/smtp
  def smtp
    @smtp_settings = SmtpSettings.new
  end

  # PUT /settings/smtp
  def smtp_update
    @smtp_settings = SmtpSettings.new smtp_settings_params
    if @smtp_settings.save_settings
      redirect_to settings_smtp_path, notice: "SMTP settings successfully saved"
    else
      flash.now[:alert] = "SMTP settings couldn't be saved"
      render 'settings/smtp'
    end
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

  # GET /settings/hooks
  def hooks
    @logs = WebhookLog.paginate(page: params[:page]).order(created_at: :desc)
    @event_invoice_generation_url = Settings.event_invoice_generation_url
  end

  # PUT /settings/hooks
  def hooks_update
    Settings[:event_invoice_generation_url] = params[:event_invoice_generation_url]
    redirect_to action: :hooks
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

  def smtp_settings_params
    params.require(:smtp_settings).permit(:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject)
  end

end
