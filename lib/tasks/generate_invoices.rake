namespace :siwapp do
  desc "Generates pending recurring invoices."
  task :generate_invoices do
    for r in RecurringInvoice.with_pending_invoices do
      r.generate_pending_invoices
    end
  end
end
