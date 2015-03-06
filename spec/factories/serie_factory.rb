FactoryGirl.define do
  factory :serie do
    name 'Example Series'
    value 'ES'
    next_number 1
    enabled true
  end

  factory :serie_random, class: Serie do
    sequence(:name, "A")  { |n| "Sample Series #{n}" }
    sequence(:value, "A") { |n| "SS#{n}" }
    next_number           { rand(1..10) }
    enabled true
  end
end
