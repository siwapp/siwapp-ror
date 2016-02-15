class ApplicationMailer < ActionMailer::Base
  email_property = Property.find_by key: 'company_email'
  if email_property
    default from: email_property.value
  end
end
