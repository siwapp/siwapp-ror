require 'rails_helper'

feature 'Viewing taxes' do
  scenario 'Listing all taxes' do
    tax = FactoryGirl.create(:tax)
    visit "/taxes"
    click_link "example tax"
    expect(page.current_url).to eql(tax_url(tax))
  end
end
