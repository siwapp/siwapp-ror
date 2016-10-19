class SmtpSettings
  include ActiveModel::Model

  attr_accessor :host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject

  validates :port, numericality: {only_integer: true, greater_than: 0}, allow_blank: true
 # validates :domain, format: {with: /\A((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: 'bad format'}, allow_blank: true
 # validate :host_is_legal


  def save_settings
    if valid?
      [:host, :port, :domain, :user, :password, :authentication, :enable_starttls_auto, :email_body, :email_subject].each do |key|
        if key == :password
          puts send key
        end
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

  private

  # host can be either domain-lik or ip-like
  def host_is_legal
    if host.blank?
      return
    end
    if /[a-z]/i.match host # alphanumeric
      test = /\A((?:[-a-z0-9]+\.)+[a-z]{2,})\z/.match host
    else # ip address
      test = /^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$/.match host
    end
    errors.add(:host, "bad format") unless test
  end

end
