FactoryGirl.define do

  factory :item do
    sequence :description do |n|
      "Item example description #{n}"
    end
    quantity 5
    unitary_cost 3.33
    common
  end

  factory :item_random, class: Item do
    quantity { rand(1..10) }
    unitary_cost { rand(1..100.0).round(2) }

    after(:create) do |item|
      vat = Tax.find_by(is_default: true) || create(:tax)
      item.taxes << vat
      if [true, false].sample
        irpf = Tax.find_by(is_retention: true) || create(:tax, value: 19, is_default: false, is_retention: true, vat_prefix: "IRPF")
        item.taxes << irpf
      end
    end
  end

end
