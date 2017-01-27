namespace :siwapp do
  desc "Generates pending recurring invoices."
  task :generate_invoices => :environment do
    RecurringInvoice.build_pending_invoices!
  end
end
