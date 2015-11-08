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

  scenario 'Adding payments to an Invoice', js: true, driver: :webkit do

    # click over "add payment", 
    add_payment_el = find('a.add_fields[data-association=payment]')
    add_payment_el.click

    # a new payment div appears ...
    new_payment_xpath = "//div[not(@style) and @class='js-payment'][a[contains(@class, 'dynamic')]]"
    expect(page).to have_selector(:xpath, new_payment_xpath)

    # .. with right default values
    within :xpath, new_payment_xpath do
      # amount: what's left to pay (0 in this case)
      expect(find('input[name*="amount"]').value).to eq "0"
      # date: today
      expect(find('input[name*="date"]').value).to eq Date.today.iso8601
      # remove this element 
      find('a.remove_fields').click
    end
    # After removing the payment, the div is gone
    expect(page).to have_no_selector(:xpath, new_payment_path)

    # first real payment
    first_payment_remove_link_xpath = '//div[input[@name="invoice[payments_attributes][0][date]"]]'
    first_payment_remove_link_xpath << '//a[contains(@class, "remove")]'
    find(:xpath, first_payment_remove_link_xpath).click
    # wait for it to be removed
    expect(page).to have_no_selector(:xpath, first_payment_remove_link_xpath)

    # re-add payment
    add_payment_el.click
    within :xpath, new_payment_xpath do
      # the unpaid amount is 100
      expect(find('input[name*="amount"]').value).to eq "100"
    end

  end
end

