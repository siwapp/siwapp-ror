require 'factory_bot_rails'

namespace :siwapp do
  namespace :random do

    desc "Create random invoices for testing and development."
    task :invoices, [:number, :due] => :environment do |t, args|
      args.with_defaults(:number => "8")
      args.with_defaults(:due => "2")

      n = args[:number].to_i
      n_due = args[:due].to_i

	  FactoryBot.create_list(:due_invoice, n_due, first_day: Date.current - n - n_due)
      FactoryBot.create_list(:demo_invoice, n, first_day: Date.current - n)
    end

    desc "Create random recurring invoices for testing and development."
    task :recurring_invoices, [:number] => :environment do |t, args|
      args.with_defaults(:number => "4")
      FactoryBot.create_list(:demo_recurring_invoice, args[:number].to_i)
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
    end
  end

  namespace :demo do
    desc 'Deletes all data and puts some demo data.'
    task :setup, [:noinput] => :environment do |t, args|
      args.with_defaults(:noinput => false)
      def setup_demo
        Rake::Task['db:seed'].invoke
        Rake::Task['siwapp:random:all'].invoke
        Rake::Task['siwapp:user:create'].invoke('demo', 'demo@example.com', 'secret')
      end
      if args[:noinput] == "noinput"
        setup_demo
      else
        puts "\n This will remove all data in database. Are you sure? [y/N]"
        answer = STDIN.gets.chomp
        if answer == "y"
          setup_demo
        else
          puts "Coward!"
        end
      end
    end
  end

end
