FactoryGirl.define do
  factory :recurring_invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie
    number 1

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
