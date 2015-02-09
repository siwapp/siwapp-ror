FactoryGirl.define do
  factory :invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    number "1"

    factory :invoice_random do
      customer_name { ["Acme, inc.",
                       "Widget Corp",
                       "Warehousing",
                       "Demo Company",
                       "Smith and Co."
      ].sample }
    end
  end
end
