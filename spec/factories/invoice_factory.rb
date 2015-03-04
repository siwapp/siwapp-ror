FactoryGirl.define do
  factory :invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie
    number 1

    factory :invoice_random do
      # Find an existing series or generate a random one
      serie { Serie.all.sample || generate(:serie_random) }

      # Set the invoice number to the next number in the current series
      number { serie.next_number }

      customer_name do
        ["Acme, inc.", "Widget Corp", "Warehousing", "Demo Company",
         "Smith and Co."].sample
      end

      after(:create) do |invoice|
        create_list(:item_random, rand(1..10), common: invoice)
        create_list(:payment_random, rand(1..10), invoice: invoice)
      end
    end
  end
end
