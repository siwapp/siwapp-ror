FactoryBot.define do
  factory :token, class: Settings do
    var   { "api_token" }
    value { "123token" }
  end
end
