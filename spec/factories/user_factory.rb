FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'testuser@example.org' }
    password { 'testuser' }
    password_digest { "$2a$10$Ane3qzvv9wzinCQ.GjD4zuioQ5RNJAfq6wj1z5NBAwmuJkHD/KeOK" } # testuser
  end
end
