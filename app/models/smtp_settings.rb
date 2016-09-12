class SmtpSettings
  include ActiveModel::Model

  attr_accessor :host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject

  def save_settings
    if valid?
      [:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject].each do |key|
        Settings[key] = send key
      end
    else
      return false
    end
  end

  def initialize(attributes={})
    [:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject].each do |key|
      send "#{key}=", "#{attributes[key] || Settings[key]}"
    end
  end

end
