FactoryGirl.define do

  factory :item do
    transient do
      with_retention false
    end

    sequence :description do |n|
      "Item example description #{n}"
    end
    quantity 5
    unitary_cost 3.33
    discount 0
    common

    factory :item_complete do
      after(:build) do |item, evaluator|
        vat = Tax.find_by(is_default: true) || build(:tax)
        item.taxes << vat
        if evaluator.with_retention
          item.taxes << (Tax.find_by(is_retention: true) || build(:tax_retention))
        end
      end
    end
  end

  factory :item_random, class: Item do
    quantity { rand(1..10) }
    unitary_cost { rand(1..100.0).round(2) }

    after(:build) do |item|
      vat = Tax.find_by(is_default: true) || build(:tax)
      item.taxes << vat
      if [true, false].sample
        irpf = Tax.find_by(is_retention: true) || build(:tax_retention)
        item.taxes << irpf
      end
    end
  end

end
