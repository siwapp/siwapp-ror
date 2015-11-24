FactoryGirl.define do
  factory :customer do
    customers = [
      {"name":"Acme, inc.",
       "id":"A-1234",
       "email":"info@acme.com"},
      {"name":"Widget Corp",
       "id":"B-1234",
       "email":"info@widgetcorp.com"},
      {"name":"Warehousing",
       "id":"C-1234",
       "email":"info@warehousing.com"},
      {"name":"Demo Company",
       "id":"D-1234",
       "email":"info@democompany.com"},
      {"name":"Smith and Co.",
       "id":"E-1234",
       "email":"info@smithandco.com"}
    ]
    sequence :name do |n|
      if n <= customers.count
        customers[n-1][:name]
      end
    end
    sequence :identification do |n|
      if n <= customers.count
        customers[n-1][:id]
      end
    end
    sequence :email do |n|
      if n <= customers.count
        customers[n-1][:email]
      end
    end

  end
end
