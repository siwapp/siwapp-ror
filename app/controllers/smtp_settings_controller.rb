class SmtpSettingsController < ApplicationController

  def edit
    @smtp_settings = SmtpSettings.new
    respond_to do |format|
      format.html
    end
  end

  def update
    @smtp_settings = SmtpSettings.new smtp_settings_params

    respond_to do |format|
      if @smtp_settings.save_settings
        format.html { redirect_to smtp_settings_edit_path, notice: "SMTP settings successfully saved"}
      else
        flash.now[:alert] = "SMTP settings couldn't be saved"
        format.html { render 'smtp_settings/edit' }
      end
    end
  end

  private
  def smtp_settings_params
    params.require(:smtp_settings).permit(:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject)
  end

end
