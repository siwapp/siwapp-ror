FactoryGirl.define do

  factory :recurring_invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie

    starting_date Date.today
    finishing_date Date.today >> 1  # 1 month later
  end

  factory :recurring_invoice_random, class: RecurringInvoice do
    sequence(:customer_name, "A")  { |n| "John #{n}. Smith" }
    sequence(:customer_email, "a") { |n| "john.#{n}.smith@example.com" }

    # Find an existing series or generate a random one
    serie { Serie.all.sample || generate(:serie_random) }

    # Set random start (past/present) and finish (present/future) dates
    starting_date { Date.today >> rand(-8..1) }
    finishing_date { Date.today >> rand(1..12) }

    after(:create) do |recurring_invoice|
      create_list(:item_random, rand(1..10), common: recurring_invoice)
      recurring_invoice.set_amounts!
    end
  end

end
