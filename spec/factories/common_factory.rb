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
    end

    factory :recurring_invoice, class: RecurringInvoice do
      starting_date { Date.current }
      period_type "month"
      period 1
    end
  end
end
