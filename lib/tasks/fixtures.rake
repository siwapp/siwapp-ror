desc "Creates invoices for testing purposes"
task :generate_invoices, [:arg1] => :environment do |t, args|
  args.with_defaults(:arg1 => 10)
  1.upto(Integer(args[:arg1])) do |i|
    item = InvoiceItem.create(:description => 'test description',
                              :quantity => 1 + Integer(rand * 10),
                              :discount => 0,
                              :unitary_cost => (rand * 10).round(2))
    invoice = Invoice.create(:number => i,
                             :customer_name => 'test customer',
                             :customer_identification => 'X123',
                             :customer_email => 'test@test.com')
    invoice.invoice_items = [item]
    invoice.save!
  end
end
