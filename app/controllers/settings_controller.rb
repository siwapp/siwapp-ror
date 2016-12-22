class SettingsController < ApplicationController

  force_ssl only: [:api_token], if: :is_production

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

  # GET /settings/tags
  def tags
    @common_tags = tags_for 'Common'
    @customer_tags = tags_for 'Customer'
  end

  # PUT /settings/tags
  def tags_update
    ids = params['tag_ids']
    tags = ActsAsTaggableOn::Tag.where(id: ids)
    tags.each do |tag|
      if params[:tags][tag.id.to_s][:_delete]
        tag.destroy
      else
        tag.name = params[:tags][tag.id.to_s][:name]
        tag.save
      end
    end
    redirect_to settings_tags_path
  end

  # GET /settings/profile
  def profile
    @user = current_user
  end

  # PUT /settings/profile
  def profile_update
    @user = current_user
    if !params[:user][:password].blank? and !@user.authenticate(params[:old_password])
      @user.errors[:base] = "Incorrect old password"
      test = false
    else
      @user.update profile_params # danger. when valid, updates password_digest by itself
      test = @user.save
    end
    if test
      redirect_to settings_profile_path, notice: "User profile successfully saved"
    else
      flash.now[:alert] = "User profile couldn't be updated"
      render 'settings/profile'
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

  def is_production
    not (Rails.env.development? || Rails.env.test?)
  end

  def profile_params
    params.require(:user).permit(:password, :password_confirmation, :name, :email)
  end

  def global_settings_params
    params.require(:global_settings).permit(:company_name, :company_vat_id, :company_address, :company_phone, :company_email, :company_url, :company_logo, :currency, :legal_terms, :days_to_due)
  end

  def smtp_settings_params
    params.require(:smtp_settings).permit(:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject)
  end

end
