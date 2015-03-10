FactoryGirl.define do

  factory :invoice do
    draft false
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie

    factory :invoice_complete do
      after(:create) do |invoice|

        # Add some items
        # - 2x >> qty: 5 / price: 3.33 / discount: 0% / VAT: 21% / IRPF: 19%
        create_list(:item_complete, 2, common: invoice, with_retention: true)
        # - 1x >> qty: 1 / price: 100 / discount: 10% / VAT: 21% / IRPF: 19%
        create(:item_complete, common: invoice, quantity: 1, unitary_cost: 100, discount: 10, with_retention: true)

        # Add some payments
        create(:payment, invoice: invoice, date: Date.today, amount: 100)
        create(:payment, invoice: invoice, date: Date.today + 1, amount: 25.766)

        invoice.set_amounts
        # base:      133.30
        # discount:      10
        # net:       123.30
        # tax:        2.466
        # gross:    125.766
        # paid:     125.766
      end
    end
  end

  factory :invoice_random, class: Invoice do
    draft {rand > 0.5}
    sequence(:customer_name, "A")  { |n| "John #{n}. Smith" }
    sequence(:customer_email, "a") { |n| "john.#{n}.smith@example.com" }

    # Find an existing series or generate a random one
    serie  { Serie.all.sample || generate(:serie_random) }

    after(:create) do |invoice|
      # Items
      create_list(:item_random, rand(1..10), common: invoice)

      # Payments
      invoice.reload.set_amounts

      max_payments = rand(1..4)
      paid_amount = invoice.gross_amount / max_payments

      # Decide whether to pay the entire invoice, part or none.
      max_payments -= rand(0..max_payments)

      if max_payments > 0
        create_list(:payment_random, max_payments, invoice: invoice, amount: paid_amount)
      end

      # Update totals in db, these fixtures are for dev purposes
      invoice.reload.set_amounts!
    end
  end

end


