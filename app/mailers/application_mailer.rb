class ApplicationMailer < ActionMailer::Base
  self.delivery_method = :smtp
  # Filling in the settings
  self.smtp_settings = {
    address:              Settings.host,
    port:                 587,
    domain:               Settings.domain,
    user_name:            Settings.user,
    password:             Settings.password,
    authentication:       Settings.authentication,
    enable_starttls_auto: Settings.enable_starttls_auto == '1' ? true : false 
  }
  self.raise_delivery_errors = true
end
