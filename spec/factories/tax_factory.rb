FactoryGirl.define do
  factory :tax do
    transient do
      vat_prefix "VAT"
    end

    name { "#{vat_prefix} #{value}%" }
    value 21

    # Only one default tax in db at a time
    is_default { Tax.find_by(is_default: true).nil? ? true : false }
    is_retention false  # IRPF, this must be specified manually
    active true
  end
end
