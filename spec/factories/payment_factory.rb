FactoryBot.define do
  factory :payment do
    date { Date.current }
    amount { 10 }
  end

  factory :payment_random, class: Payment do
    date { Date.current }
    amount { rand(1..10) }
    notes do
      pay_method = ['visa', 'mastercard', 'american express'].sample
      "Paid by #{pay_method}."
    end
  end
end
