FactoryGirl.define do
  factory :item do
    sequence :description do |n|
      "Item example description #{n}"
    end
    quantity 5
    unitary_cost 3.33
    common

    factory :item_random do
      quantity { rand(1..10) }
      unitary_cost { rand(1..100.0).round(2) }
    end
  end
end
