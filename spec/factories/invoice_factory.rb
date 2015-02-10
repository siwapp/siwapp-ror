FactoryGirl.define do
  factory :common do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    number "1"

    factory :invoice do
      type "Invoice"

      factory :invoice_random do
        customer_name { ["Acme, inc.",
                         "Widget Corp",
                         "Warehousing",
                         "Demo Company",
                         "Smith and Co."
        ].sample }
        after(:create) do |invoice|
          create_list(:item, rand(10), common: invoice)
        end
      end
    end

  end
end
