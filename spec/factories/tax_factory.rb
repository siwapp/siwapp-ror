FactoryGirl.define do
  factory :tax do
    value 21
    name { "VAT #{value}%" }

    is_default false
    is_retention false
    active true

    factory :tax_retention do
      value 19
      name { "IRPF #{value}%" }
      is_retention true
    end
  end
end
