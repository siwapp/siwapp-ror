class SmtpSettingsController < ApplicationController

  def edit
    @smtp_settings = SmtpSettings.new
    respond_to do |format|
      format.html
    end
  end

  def update
    @smtp_settings = SmtpSettings.new smtp_settings_params
    @smtp_settings.save_settings
    respond_to do |format|
      format.html { redirect_to action: :edit}
    end
  end

  private
  def smtp_settings_params
    params.require(:smtp_settings).permit(:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject)
  end

end
