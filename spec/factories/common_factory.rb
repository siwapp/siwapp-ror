FactoryGirl.define do
  factory :common do

    draft false

    # FOR TESTS
    factory :common_fixed do
      name  "Example Customer Name"
      email "example@example.com"


      series

      after(:create) do |common|
        # Add some items
        # - 2x >> qty: 5 / price: 3.33 / discount: 0% / VAT: 21% / RETENTION: -19%
        create_list(:item_complete, 2, common: common, with_retention: true)
        # - 1x >> qty: 1 / price: 100 / discount: 10% / VAT: 21% / RETENTION: -19%
        create(:item_complete, common: common, quantity: 1, unitary_cost: 100, discount: 10, with_retention: true)

        # super weird thing. iterating through invoice.items or invoice.payments
        # BEFORE the create_list calls, makes the newly created children not to
        # be bound to invoice so we need to reload it.
        common.reload

        # base:      133.30
        # discount:      10
        # net:       123.30
        # tax:        2.466
        # gross:    125.766
        common.save
      end

      factory :invoice, class: Invoice do
        issue_date Date.today - 1
        due_date Date.today + 30
        after(:create) do |invoice|
          # Add some payments
          create(:payment, invoice: invoice, date: Date.today, amount: 100)
          create(:payment, invoice: invoice, date: Date.today + 1, amount: 25.766)

          # super weird thing. iterating through invoice.items or invoice.payments
          # BEFORE the create_list calls, makes the newly created children not to
          # be bound to invoice so we need to reload it.
          invoice.reload

          # paid:     125.766
          invoice.save
        end
      end

      factory :invoice_unpaid, class: Invoice do
        issue_date Date.today - 1
        due_date Date.today + 30
        after(:create) do |i|
          create(:payment, invoice: i, date: Date.today, amount: 100)
          i.reload
          # unpaid: 25.766
          i.save
        end
      end

      factory :recurring_invoice, class: RecurringInvoice do
        starting_date Date.today
        finishing_date Date.today + 7  # 1 week later
        period 1
        period_type "days"
        max_occurrences 5
      end
    end

    # FOR DEVELOPMENT
    factory :common_random do
      factory :invoice_random, class: Invoice do
        draft {rand > 0.5}
        issue_date Date.today - 1
        due_date Date.today + 30

        customer { Customer.all.sample }
        name { customer.name }
        identification { customer.identification }
        email { customer.email }
        series  { Series.all.sample }

        after(:create) do |invoice|
          # Items
          create_list(:item_random, rand(1..10), common: invoice)

          # Payments
          invoice.reload

          max_payments = rand(1..4)
          paid_amount = invoice.gross_amount / max_payments

          # Decide whether to pay the entire invoice, part or none.
          max_payments -= rand(0..max_payments)

          if max_payments > 0
            create_list(:payment_random, max_payments, invoice: invoice, amount: paid_amount)
          end

          invoice.save
        end
      end

      factory :recurring_invoice_random, class: RecurringInvoice do
        name { ["Acme, inc.",
                "Widget Corp",
                "Warehousing",
                "Demo Company",
                "Smith and Co."
        ].sample }
        series { Series.all.sample }

        # Set random start (past/present) and finish (present/future) dates
        starting_date { Date.today >> rand(-8..1) }
        finishing_date { Date.today >> rand(1..12) }

        period { rand(1..10) }
        period_type {['days', 'months', 'years'].sample }

        after(:create) do |recurring_invoice|
          create_list(:item_random, rand(1..10), common: recurring_invoice)
          recurring_invoice.save
        end
      end
    end

  end
end
