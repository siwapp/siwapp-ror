class ApplicationMailer < ActionMailer::Base
  self.smtp_settings = {
    address:              Settings.host,
    port:                 Settings.port.to_i,
    domain:               Settings.domain,
    user_name:            Settings.user,
    password:             Settings.password,
    authentication:       Settings.authentication,
    enable_starttls_auto: Settings.enable_starttls_auto == '1' ? true : false
  }
end
