require 'factory_girl_rails'

namespace :siwapp do
  namespace :random do

    desc "Create random invoices for testing and development."
    task :invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "10")
      if Customer.count == 0
        FactoryGirl.create_list(:customer, 5)
      end
      if Series.count == 0
        FactoryGirl.create_list(:series_random, 3)
      end
      if Tax.count == 0
        FactoryGirl.create(:tax, value: 21, is_default: true)
        FactoryGirl.create(:tax, value: 10)
        FactoryGirl.create(:tax, value: 4)
        FactoryGirl.create(:tax_retention)
      end
      FactoryGirl.create_list(:invoice_random, args[:number].to_i)
    end

    desc "Create random recurring invoices for testing and development."
    task :recurring_invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "10")
      FactoryGirl.create_list(:recurring_invoice_random, args[:number].to_i)
    end

    desc "Create a basic set of series, taxes, invoices and recurring invoices."
    task :all do
      Rake::Task['siwapp:random:invoices'].invoke
      Rake::Task['siwapp:random:recurring_invoices'].invoke
    end
  end

  namespace :user do
    desc 'Creates user account with given credentials: rake user:create'
    # environment is required to have access to Rails models
    task :create, [:name, :email, :pass] => :environment do |t, args|
      puts "creating user account..."
      u = Hash.new
      u[:name] = args[:name]
      u[:email] = args[:email]
      u[:password] = args[:pass]
      # with some DB layer like ActiveRecord:
      user = User.new(u); user.save!
      puts "user: " + u.to_s
      puts "account created."
      exit 0
    end
  end
end
