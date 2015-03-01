FactoryGirl.define do
  factory :common do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    number "1"
    serie

    factory :invoice do
      type "Invoice"
      
      factory :invoice_random do
        association :serie, factory: :serie_random
        customer_name { ["Acme, inc.",
                         "Widget Corp",
                         "Warehousing",
                         "Demo Company",
                         "Smith and Co."
        ].sample }
        after(:create) do |invoice|
          create_list(:item_random, rand(1..10), common: invoice)
        end
      end
    end

    factory :recurring_invoice do
      type "RecurringInvoice"
      starting_date Date.today
      finishing_date Date.tomorrow

      factory :recurring_invoice_random do
        association :serie, factory: :serie_random
        customer_name { ["Acme, inc.",
                         "Widget Corp",
                         "Warehousing",
                         "Demo Company",
                         "Smith and Co."
        ].sample }
        starting_date Date.today
        finishing_date Date.tomorrow
        after(:create) do |invoice|
          create_list(:item_random, rand(1..10), common: invoice)
        end
      end
    end

  end
end
