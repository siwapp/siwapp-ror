require 'rails_helper'

feature 'Creating Customer' do

  before do
    visit '/customers'

    first(:link, 'New Customer').click
  end

  scenario 'can create a Customer', :js => true, driver: :webkit do
    expect(page).to have_content('New Customer')

    fill_in 'Name', with: 'Test Customer'

    click_on 'Save'
	expect(page).to have_content('Customer was successfully created.')

    expect(page.current_path).to eql customers_path
  end

  scenario 'can not create a Customer without name', :js => true, driver: :webkit do
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name or identification is required.")
    expect(page).to have_content('1 error prohibited this customer from being saved:')
  end

end
