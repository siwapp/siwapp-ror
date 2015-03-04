FactoryGirl.define do
  factory :invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie
    number 1

    factory :invoice_random do
      association :serie, factory: :serie_random
      sequence(:number)
      customer_name { ["Acme, inc.",
                       "Widget Corp",
                       "Warehousing",
                       "Demo Company",
                       "Smith and Co."
      ].sample }
      after(:create) do |invoice|
        create_list(:item_random, rand(1..10), common: invoice)
        create_list(:payment_random, rand(1..10), invoice: invoice)
      end
    end
  end
end
