FactoryBot.define do
  factory :template do
    name { "print_default" }
    template { "fake template" }
    print_default { true }

    factory :print_template do
      name { "Print Default" }
      template { "PDF Template" }
      print_default { true }
      email_default { false }
    end

    factory :email_template do
      name { "Email Default" }
      template { "Email Template" }
      email_default { true }
      print_default { false }
    end
  end
end
