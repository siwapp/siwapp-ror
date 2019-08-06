FactoryBot.define do
  factory :customer do
    name { "Test Customer" }
    name_slug { "#{name.gsub(/^[^\w]+|[^\w]+$/i, '').gsub(/[^\w]+/i, '-').downcase}" }
    identification { "12345" }
    email  { "customer@example.com" }

    # WARNING: DON'T USE FOR TESTS!!!
    factory :demo_customer do
      name { Faker::Company.unique.name }
      identification { Faker::Code.unique.asin }
      contact_person { Faker::Name.unique.name }
      email { "info@#{name_slug}.com" }
      invoicing_address do
        address = Faker::Address.unique.street_address
        address << "\n#{Faker::Address.unique.secondary_address}"
        address << "\n#{Faker::Address.unique.zip} #{Faker::Address.city}"
        address << "\nUSA"
        address
      end
    end
  end

  factory :ncustomer, class: Customer do
    customers = [
      "Acme, Inc.",
      "Widget Corp.",
      "Warehousing",
      "Demo Company",
      "Smith & Co.",
    ]

    sequence(:name, 0)              { |n| n < customers.length ? customers[n] : "Customer #{n}" }
    sequence(:identification, "A")  { |n| "1234#{n}" }
    email                           { "info@#{name.gsub(/^[^\w]+|[^\w]+$/i, '').gsub(/[^\w]+/i, '-').downcase}.com" }
  end
end
