FactoryGirl.define do
  factory :settings do
    factory :token do
      var 'api_token'
      value '123token'
    end
  end
end
