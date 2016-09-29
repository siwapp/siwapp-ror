FactoryGirl.define do
  factory :template do
    name "email_default"
    name "print_default"
    template "fake template"
    default true
  end
end
