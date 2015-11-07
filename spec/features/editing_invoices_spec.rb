require 'rails_helper'

feature 'Editing Invoices' do

  before do
    FactoryGirl.create(:invoice)
    visit "/invoices"
    click_link "ES-1"
    click_link "Edit"
  end

  scenario 'Updating an Invoice' do
    fill_in 'Name', with: 'Different Name'
    fill_in 'Email', with: 'different.name@test.com'
    fill_in 'Due date', with: Date.today + 30
    click_button 'Update Invoice'
    expect(page).to have_content("Invoice was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Name', with: ''
    fill_in 'Email', with: 'pepe.com'
    click_button 'Update Invoice'
    expect(page).to have_content('Invoice has not been saved')
    expect(page).to have_content("Only valid emails")
  end

  scenario 'default payment fields values', js: true, driver: :webkit do

    # click over "add payment", create new payment
    add_payment_el = find('a.add_fields[data-association=payment]')
    add_payment_el.click
    # find the newly added div.js-payment
    new_payment_xpath = "//div[not(@style) and @class='js-payment'][a[contains(@class, 'dynamic')]]"

    # check default values
    within :xpath, new_payment_xpath do
      # the invoice is fully paid. 0 default amount value
      expect(find('input[name*="amount"]').value).to eq "0"
      # the date should be today
      expect(find('input[name*="date"]').value).to eq "2015-11-07" #Date.today.iso8601
      # remove this element so it's easier to find it when re-adding
      find('a.remove_fields').click
    end

    # remove real payment, so the invoice goes to 'pending'
    first_payment_xpath = '//div[@class="js-payment" and .//a[contains(@class, "existing")]][1]'
    first_payment_div = find :xpath, first_payment_xpath

    within :xpath, first_payment_xpath do
      # look for any element inside the first div
      first_id = all('*[id]').first[:id]
      # remove the first payment
      find('a.remove_fields.existing').click
      # wait for the element to be removed
      expect(page).to have_no_selector("##{first_id}")
    end

    # readd payment, this one has to have amount
    add_payment_el.click
    within :xpath, new_payment_xpath do
      expect(find('input[name*="amount"]').value).to eq "100"
    end

  end
end

