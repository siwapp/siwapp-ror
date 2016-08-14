class GlobalSettingsController < ApplicationController

  def new
    @global_settings = GlobalSettings.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @global_settings = GlobalSettings.new global_settings_params
    @global_settings.save_settings
    respond_to do |format|
      format.html { redirect_to action: :new}
    end
  end

  private
  def global_settings_params
    params.require(:global_settings).permit(:company_name, :company_vat_id, :company_address, :company_phone, :company_email, :company_url, :company_logo, :currency, :legal_terms, :days_to_due)
  end
  
end
