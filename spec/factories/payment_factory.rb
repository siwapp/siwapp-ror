FactoryGirl.define do
  factory :payment do
    date Date.today
    amount 10
    notes "Paid by bank account."

    factory :payment_random do
      date Date.today
      amount { rand(1..10) }
      notes do
        pay_method = ['visa', 'mastercard', 'american express'].sample
        "Paid by #{pay_method}."
      end
    end
  end
end
