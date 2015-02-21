FactoryGirl.define do
  factory :serie do
    name 'example serie'
    value 'ES'
    first_number 1
    enabled true
    
    factory :serie_random do
      name { ["Agricultural supplies", 
              "Internet Services",
              "Escort Services"
             ].sample }
      value { ["AS", "IS", "ES"].sample}
      first_number {rand(1..10)}
    end
  end
end
