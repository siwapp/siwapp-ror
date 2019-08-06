FactoryBot.define do
  factory :series do
    name { "A- Series" }
    value { "A-" }

    trait :default do
      default { true }
    end

    trait :disabled do
      enabled { false }
    end
  end

  factory :b_series, class: Series do
    name { "B- Series" }
    value { "B-" }
    first_number { 3 }
  end

  factory :nseries, class: Series do
    sequence(:name, "A")  { |n| "#{n}- Series" }
    sequence(:value, "A") { |n| "#{n}-"        }
    sequence(:default)    { |n| n === 1        }
  end
end
