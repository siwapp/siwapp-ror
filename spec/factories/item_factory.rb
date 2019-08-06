FactoryBot.define do

  factory :item do
    description { "Invoicing App Development" }
    unitary_cost { 10000 }

    after :build do |item|
      item.taxes << (Tax.find_by(id: 1) || create(:vat))
      item.taxes << (Tax.find_by(id: 2) || create(:retention))
    end

    # WARNING: DON'T USE FOR TESTS!!!
    trait :invoice_item_demo do
      unitary_cost { Faker::Commerce.price * 1000 }
      description { "#{Faker::App.unique.name} App Development" }
    end

    # WARNING: DON'T USE FOR TESTS!!!
    trait :recurring_invoice_item_demo do
      description { "Website Maintenance" }
      unitary_cost { Faker::Commerce.price * 10 }
    end
  end

end
