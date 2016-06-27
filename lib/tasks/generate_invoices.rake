namespace :siwapp do
  desc "Generates pending recurring invoices."
  task :generate_invoices => :environment do
  	generated_invoices = []
    for r in RecurringInvoice.with_pending_invoices do
      generated_invoices += r.generate_pending_invoices
    end
    generated_invoices.sort_by(&:issue_date).each do |inv|
    	if inv.save
    		inv.send_by_email if inv.recurring_invoice.sent_by_email
    	end
    end	
  end
end
