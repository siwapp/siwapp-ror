class ApplicationMailer < ActionMailer::Base
  self.delivery_method = :smtp
  self.smtp_settings = {
    address:              Settings.host,
    port:                 Settings.port,
    domain:               Settings.domain,
    user_name:            Settings.user,
    password:             Settings.password,
    authentication:       :plain,
    enable_starttls_auto: true
  }
  self.raise_delivery_errors = true
  email_property = Settings.company_email
  if email_property
    default from: email_property
  end
end
