FactoryGirl.define do

  factory :item do
    description "Invoicing App Development"
    unitary_cost 10000

    after :build do |item|
      item.taxes << (Tax.find_by(id: 1) || create(:vat))
      item.taxes << (Tax.find_by(id: 2) || create(:retention))
    end
  end

end
