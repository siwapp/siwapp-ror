require 'factory_girl_rails'

namespace :siwapp do
  namespace :random do
    desc "Create random series for testing and development."
    task :series, [:number] => :environment do |t, args|
      args.with_defaults(:number => "3")
      FactoryGirl.create_list(:serie_random, args[:number].to_i)
    end

    desc "Create a set of taxes for testing and development."
    task :taxes => :environment do |t|
      FactoryGirl.create(:tax, value: 21) if Tax.find_by(is_default: true).nil?
      FactoryGirl.create(:tax, value: 10, is_default: false) if Tax.find_by(value: 10).nil?
      FactoryGirl.create(:tax, value: 4, is_default: false) if Tax.find_by(value: 4).nil?
      FactoryGirl.create(:tax, value: 19, is_default: false, is_retention: true, vat_prefix: "IRPF") if Tax.find_by(is_retention: true).nil?
    end

    desc "Create random invoices for testing and development."
    task :invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "10")
      FactoryGirl.create_list(:invoice_random, args[:number].to_i)
    end

    desc "Create random recurring invoices for testing and development."
    task :recurring_invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "10")
      FactoryGirl.create_list(:recurring_invoice_random, args[:number].to_i)
    end
  end
end
