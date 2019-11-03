# RailsSettings Model
class Settings < RailsSettings::Base
  # Global
  field :api_token
  field :currency, default: "eur"
  field :days_to_due, default: 0
  field :company_logo
  field :company_name
  field :company_address
  field :company_phone
  field :company_vat_id
  field :company_url
  field :company_email
  field :legal_terms
  # Smtp
  field :host
  field :port, type: :integer
  field :domain
  field :user
  field :password
  field :authentication
  field :enable_starttls_auto, type: :boolean
  field :email_subject
  field :email_body
  # Hooks
  field :event_invoice_generation_url
end
