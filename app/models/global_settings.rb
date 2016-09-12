class GlobalSettings
  include ActiveModel::Model

  attr_accessor :company_name, :company_vat_id, :company_address, :company_phone, :company_url, :legal_terms, :days_to_due, :company_email, :company_logo, :currency, :legal_terms, :days_to_due

  def save_settings
    self.company_logo = self.company_logo.gsub('https://', 'http://') if self.company_logo
    [:company_name, :company_vat_id, :company_address, :company_phone, :company_url, :legal_terms, :days_to_due, :company_email, :company_logo, :currency, :legal_terms, :days_to_due].each do |key|
      Settings[key] = send key
    end
  end

  def initialize(attributes={})
    [:company_name, :company_vat_id, :company_address, :company_phone, :company_url, :legal_terms, :days_to_due, :company_email, :company_logo, :currency, :legal_terms, :days_to_due].each do |key|
      send "#{key}=", "#{attributes[key] || Settings[key]}"
    end    
  end
  
end
