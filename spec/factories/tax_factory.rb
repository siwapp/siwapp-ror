FactoryGirl.define do
  factory :tax do
    value 21
    name { "VAT #{value}%" }

    factory :tax_retention do
      value (-19)
      name "RETENTION"
    end

    factory :irpf do
      value -15
      name { "IRPF #{value}%" }
    end
  end
end
