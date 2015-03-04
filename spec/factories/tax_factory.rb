FactoryGirl.define do
  factory :tax do
    transient do
      vat_prefix "VAT"
    end

    value 21
    name { "#{vat_prefix} #{value}%" }
    active true
    is_default { Tax.find_by(is_default: true).nil? ? true : false }
    is_retention false
  end
end
