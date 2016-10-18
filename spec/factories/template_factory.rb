FactoryGirl.define do
  factory :template do
    name "print_default"
    template "fake template"
    print_default true
  end
end
