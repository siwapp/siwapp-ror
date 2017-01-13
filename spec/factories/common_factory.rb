FactoryGirl.define do
  factory :common do
    name "Test Customer"
    identification "12345"
    email "customer@example.com"

    after :build do |common|
      common.series = common.series || Series.find_by(default: true) || create(:series, :default)

      if common.customer
        common.name = common.customer.name
        common.identification = common.customer.identification
        common.email = common.customer.email
        common.contact_person = common.customer.contact_person
        common.invoicing_address = common.customer.invoicing_address
      else
        common.customer = Customer.find_by(identification: common.identification) || create(
          :customer,
          name: common.name,
          identification: common.identification,
          email: common.email
        )
      end

      common.items << build(:item) if common.items.empty?
      common.set_amounts
    end

    factory :invoice, class: Invoice do
      issue_date { Date.current }

      trait :paid do
        after :build do |invoice|
          invoice.set_paid
        end
      end

      # WARNING: DON'T USE FOR TESTS!!!
      factory :demo_invoice do
        sequence(:issue_date, 0) { |n| Date.current + n }
        due_date { issue_date + 30 }
        
        association :customer, factory: :demo_customer, strategy: :build
        items { build_list(:item, 1, :invoice_item_demo) }

        after :build do |invoice|
          if Faker::Boolean.boolean(0.65)
            invoice.set_paid
          end
        end
      end
    end

    factory :recurring_invoice, class: RecurringInvoice do
      starting_date { Date.current }
      period_type "month"
      period 1
      days_to_due 30

      # WARNING: DON'T USE FOR TESTS!!!
      factory :demo_recurring_invoice do
        association :customer, factory: :demo_customer, strategy: :build
        items { build_list(:item, 1, :recurring_invoice_item_demo) }
      end
    end
  end
end
