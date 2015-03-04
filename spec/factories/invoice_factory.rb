FactoryGirl.define do
  factory :invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie
    number 1

    factory :invoice_random do
      serie { Serie.all.sample || generate(:serie_random) }
      number do
        invoices = serie.commons.where(type: :invoice).order(number: 'desc').limit(1)
        if invoices.any?
          invoices[0].number + 1
        else
          1
        end
      end

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
