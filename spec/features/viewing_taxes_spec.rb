require 'rails_helper'

feature 'Viewing taxes' do
  scenario 'Listing all taxes' do
    tax = FactoryGirl.create(:tax)
    visit "/taxes"
    click_link "VAT 21%"
    expect(page.current_url).to eql(tax_url(tax))
  end
end
