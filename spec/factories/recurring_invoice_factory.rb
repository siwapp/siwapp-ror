FactoryGirl.define do
  factory :recurring_invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie

    starting_date Date.today
    finishing_date Date.today >> 1  # 1 month later

    factory :recurring_invoice_random do
      # Find an existing series or generate a random one
      serie { Serie.all.sample || generate(:serie_random) }

      customer_name do
        ["Acme, inc.", "Widget Corp", "Warehousing", "Demo Company",
         "Smith and Co."].sample
      end

      # Set random start (past/present) and finish (present/future) dates
      starting_date { Date.today >> rand(-8..1) }
      finishing_date { Date.today >> rand(1..12) }

      after(:create) do |recurring_invoice|
        create_list(:item_random, rand(1..10), common: recurring_invoice)
      end
    end
  end
end
