#
# config/initializers/scheduler.rb
require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton

unless defined?(Rails::Console)
  # only schedule when not running from the Rails on Rails console

  s.every '1d' do
    for r in RecurringInvoice.with_pending_invoices do
      r.generate_pending_invoices
    end
  end

end
