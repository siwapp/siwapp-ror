FactoryGirl.define do
  factory :customer do
    name "Test Customer"
    identification "12345"
    email "customer@example.com"

    factory :ncustomer do
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
end
