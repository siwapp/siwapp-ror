class SettingsController < ApplicationController
  before_action :set_hooks_logs, only: [:hooks, :hooks_update]
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
      @user.errors.add(:base, :invalid_old_password, message: 'Incorrect old password')
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
    @hooks_settings = HooksSettings.new
  end

  # PUT /settings/hooks
  def hooks_update
    @hooks_settings = HooksSettings.new hooks_settings_params
    if @hooks_settings.save_settings
      redirect_to settings_hooks_path, notice: "Hooks settings successfully saved"
    else
      flash.now[:alert] = "Hooks settings couldn't be saved"
      render 'settings/hooks'
    end
  end


  # API Token show/generation
  def api_token
    if request.post?
      Settings.api_token = SecureRandom.uuid.gsub(/\-/,'')
      redirect_to action: :api_token
    end
    @api_token = Settings.api_token
  end



  private

  def is_production
    not (Rails.env.development? || Rails.env.test?)
  end

  def set_hooks_logs
    @logs = WebhookLog.paginate(page: params[:page]).order(created_at: :desc)
  end

  def profile_params
    params.require(:user).permit(:password, :password_confirmation, :name, :email)
  end

  def global_settings_params
    params.require(:global_settings).permit(GlobalSettings.keys)
  end

  def hooks_settings_params
    params.require(:hooks_settings).permit(HooksSettings.keys)
  end

end
