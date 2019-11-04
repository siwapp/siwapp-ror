class ApplicationMailer < ActionMailer::Base
  self.smtp_settings = {
    address:              ENV['SMTP_HOST'],
    port:                 ENV['SMTP_PORT'].to_i,
    domain:               ENV['SMTP_DOMAIN'],
    user_name:            ENV['SMTP_USER'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       ENV['SMTP_AUTHENTICATION'],
    enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] == '1' ? true : false
  }
end
