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
  field :email_subject
  field :email_body
  # Hooks
  field :event_invoice_generation_url
end
