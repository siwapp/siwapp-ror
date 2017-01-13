require 'factory_girl_rails'

namespace :siwapp do
  namespace :random do

    desc "Create random invoices for testing and development."
    task :invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "10")
      FactoryGirl.create_list(:demo_invoice, args[:number].to_i)
    end

    desc "Create random recurring invoices for testing and development."
    task :recurring_invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "4")
      FactoryGirl.create_list(:demo_recurring_invoice, args[:number].to_i)
    end

    desc "Create a basic set of series, taxes, invoices and recurring invoices."
    task :all do
      Rake::Task['siwapp:random:invoices'].invoke
      Rake::Task['siwapp:random:recurring_invoices'].invoke
    end
  end

  namespace :user do
    desc 'Creates user account with given credentials: rake siwapp:user:create[name,email,pass]'
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
