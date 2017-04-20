class HooksSettings < SiwappSettings::Base
  @keys = [:event_invoice_generation_url]

  validates :event_invoice_generation_url, :url => true
end
