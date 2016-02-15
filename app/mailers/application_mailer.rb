class ApplicationMailer < ActionMailer::Base
  self.delivery_method = :smtp
  self.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               '',
    user_name:            '',
    password:             '',
    authentication:       :plain,
    enable_starttls_auto: true
  }
  self.raise_delivery_errors = true
  email_property = Property.find_by key: 'company_email'
  if email_property
    default from: email_property.value
  end
end
