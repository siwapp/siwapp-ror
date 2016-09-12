class GlobalSettingsController < ApplicationController

  def edit
    @global_settings = GlobalSettings.new
    respond_to do |format|
      format.html
    end
  end

  def update
    @global_settings = GlobalSettings.new global_settings_params
    respond_to do |format|
      if @global_settings.save_settings
        format.html { redirect_to global_settings_edit_path, notice: "Global settings successfully saved"}
      else
        flash.now[:alert] = "Global settings could not be saved"
        format.html {render 'global_settings/edit'}
      end
    end
  end

  private
  def global_settings_params
    params.require(:global_settings).permit(:company_name, :company_vat_id, :company_address, :company_phone, :company_email, :company_url, :company_logo, :currency, :legal_terms, :days_to_due)
  end
  
end
