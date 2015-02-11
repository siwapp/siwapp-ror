require 'factory_girl_rails'

namespace :siwapp do
  desc "Create random invoices for testing and development."
  task :random, [:number] => :environment do |t, args|
    args.with_defaults(:number => "10")
    FactoryGirl.create_list(:invoice_random, args[:number].to_i)
  end
end
