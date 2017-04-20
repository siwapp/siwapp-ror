class GlobalSettings < SiwappSettings::Base
  @keys = [
    :company_name, :company_vat_id, :company_address, :company_phone,
    :company_url, :company_email, :company_logo, :currency, :legal_terms,
    :days_to_due
  ]

  validates :days_to_due,
            :numericality => {only_integer: true, greater_than_or_equal_to: 0}
  validates :company_email,
            :format => {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'bad format'},
            :allow_blank => true

  def save_settings
    if valid?
      self.company_logo = self.company_logo.gsub('https://', 'http://') if self.company_logo
    end
    super
  end
end
