require 'rails_helper'

feature 'Viewing invoices' do
  scenario 'Listing all invoices' do
    invoice = FactoryGirl.create(:invoice)
    visit "/invoices"
    expect(page).to have_content("ES-1")
  end
end
