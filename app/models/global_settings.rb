class GlobalSettings
  include ActiveModel::Model

  attr_accessor :company_name, :company_vat_id, :company_address,
                :company_phone, :company_url, :legal_terms,
                :days_to_due, :company_email, :company_logo,
                :currency, :legal_terms, :days_to_due

  validates :days_to_due,
            :numericality => {only_integer: true, greater_than_or_equal_to: 0}
  validates :company_email,
            :format => {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'bad format'},
            :allow_blank => true

  def save_settings
    if valid?
      self.company_logo = self.company_logo.gsub('https://', 'http://') if self.company_logo
      [
        :company_name, :company_vat_id, :company_address, :company_phone,
        :company_url, :legal_terms, :days_to_due, :company_email, :company_logo,
        :currency, :legal_terms, :days_to_due
      ].each do |key|
        Settings[key] = send key
      end
    else
      false
    end
  end

  def initialize(attributes={})
    [
      :company_name, :company_vat_id, :company_address, :company_phone,
      :company_url, :legal_terms, :days_to_due, :company_email, :company_logo,
      :currency, :legal_terms, :days_to_due
    ].each do |key|
      send "#{key}=", "#{attributes[key] || Settings[key]}"
    end
  end

end
