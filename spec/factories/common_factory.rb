##
# To generate random invoices do the following into the console:
# > require 'factory_girl'
# > FactoryGirl.find_definitions
#.> FactoryGirl.create_list(:invoice_random, 20)
##

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
          create_list(:item_random, rand(1..10), common: invoice)
        end
      end
    end

  end
end
