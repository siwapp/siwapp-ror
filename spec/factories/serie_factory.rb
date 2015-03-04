FactoryGirl.define do
  factory :serie do
    name 'Example Series'
    value 'ES'
    first_number 1
    enabled true

    factory :serie_random do
      sequence(:name, "A") {|n| "Sample Series #{n}"}
      sequence(:value, "A") {|n| "SS#{n}"}
      first_number {rand(1..10)}
    end
  end
end
