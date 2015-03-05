FactoryGirl.define do
  factory :invoice do
    customer_name "Example Customer Name"
    customer_email 'example@example.com'
    serie
    number 1

    factory :invoice_random do
      # Find an existing series or generate a random one
      serie { Serie.all.sample || generate(:serie_random) }

      # Set the invoice number to the next number in the current series
      number { serie.next_number }

      customer_name do
        ["Acme, inc.", "Widget Corp", "Warehousing", "Demo Company",
         "Smith and Co."].sample
      end

      after(:create) do |invoice|
        create_list(:item_random, rand(1..10), common: invoice)

        # Payments
        invoice.set_amounts
        max_payments = rand(1..4)
        paid_amount = invoice.gross_amount / max_payments

        # Randomly decide whether to pay the entire invoice, part or none.
        max_payments -= rand(0..max_payments)

        if max_payments > 0
          create_list(:payment_random, max_payments, invoice: invoice,
                      amount: paid_amount)
        end

        invoice.set_amounts!
      end
    end
  end
end
