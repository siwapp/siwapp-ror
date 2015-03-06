FactoryGirl.define do

  factory :recurring_invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie

    starting_date Date.today
    finishing_date Date.today >> 1  # 1 month later

    factory :recurring_invoice_complete do
      after(:create) do |recurring_invoice|

        # Add some items
        # - 1x >> qty: 2 / price: 100 / discount: 10% / VAT: 21%
        create(:item_complete, common: recurring_invoice, quantity: 2, unitary_cost: 100, discount: 10)

        recurring_invoice.set_amounts()
        # base:       200
        # discount:    20
        # net:        180
        # tax:       37.8
        # gross:    217.8
      end
    end
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
      recurring_invoice.set_amounts()
    end
  end

end
