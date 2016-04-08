require 'rails_helper'

RSpec.describe Customer, :type => :model do
  it "performs due and total calculations properly" do
    customer = FactoryGirl.create(:customer)
    invoice = FactoryGirl.create(:invoice, customer: customer) # gross 125.766 , unpaid 0
    unpaid_invoice = FactoryGirl.create(:invoice_unpaid, customer: customer) # gross 125.766 paid: 100
    draft_invoice = FactoryGirl.create(:invoice, draft: true, customer: customer)
    expect(customer.total).to eq 125.766*2
    expect(customer.due).to eq 25.766
  end

  it " won't be deleted if it has invoices" do
    customer = FactoryGirl.create :customer
    invoice = FactoryGirl.create :invoice, customer: customer
    expect(customer.destroy).to be false
    expect(customer.errors[:base][0]).to include "can't be deleted"
  end
end
