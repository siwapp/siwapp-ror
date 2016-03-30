require 'rails_helper'

feature 'Deleting taxes' do
  scenario 'Delete a tax from the listing page', :js => true, driver: :webkit do
    tax = FactoryGirl.create(:tax)
    visit '/taxes/1/edit'
    click_link 'Delete'
    expect(page).to have_content('Tax was successfully destroyed')
    visit '/taxes'
    expect(page).to have_no_content('VAT 21%')
  end
end
