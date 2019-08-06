FactoryBot.define do
  factory :vat, class: Tax do
    id { 1 }
    value { 21 }
    name { "VAT" }
  end

  factory :retention, class: Tax do
    id { 2 }
    value { -15 }
    name { "RETENTION" }
  end
end
