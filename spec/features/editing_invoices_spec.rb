require 'rails_helper'

feature 'Editing Invoices' do

  before do
    FactoryGirl.create(:invoice)
    visit "/invoices"
    click_link "ES-1"
    click_link "Edit"
  end

  scenario 'Updating an Invoice', :js => true, driver: :webkit do
    fill_in 'Name', with: 'Different Name'
    fill_in 'Email', with: 'different.name@test.com'
    fill_in 'Due date', with: Date.today + 30
    click_on 'Save'
    expect(page).to have_content("Invoice was successfully updated")
  end

  scenario 'Can not update badly', :js => true, driver: :webkit do
    fill_in 'Name', with: ''
    fill_in 'Email', with: 'pepe.com'
    click_on 'Save'
    expect(page).to have_content('Invoice has not been saved')
    expect(page).to have_content("Only valid emails")
  end

  scenario "Adding an item to an Invoice", js: true, driver: :webkit do
    default_tax = FactoryGirl.create :tax, default: true, active: true

    FactoryGirl.create :invoice, id: 3
    visit "/invoices/3/edit"

    # click over "add item"
    find('a.add_fields[data-association=item]').click

    # a new item div appears
    new_item_xpath = "//table/tbody/tr[4]"
    expect(page).to have_selector(:xpath, new_item_xpath)

    within :xpath, new_item_xpath do
      # default taxes
      expect(find('select option[selected="selected"]').value.to_i).to eq default_tax.id
    end
  end

  scenario 'Adding a payments to an Invoice', js: true, driver: :webkit do

    FactoryGirl.create(:invoice_unpaid, id: 3)
    visit "/invoices/3/edit"

    # click over "add payment",
    find('a.add_fields[data-association=payment]').click

    # a new payment div appears ...
    new_payment_xpath = "//div[not(@style) and @class='js-payment'][a[contains(@class, 'dynamic')]]"
    expect(page).to have_selector(:xpath, new_payment_xpath)

    within :xpath, new_payment_xpath do
      # default amount: what's left to pay
      expect(find('input[name*="amount"]').value.to_i).to eq 25
      # default date: today
      expect(find('input[name*="date"]').value).to eq Date.today.iso8601
    end

    # click over "remove payment"
    find(:xpath, "#{new_payment_xpath}//a[contains(@class, \"remove_fields\")]").click

    # ... the div is gone
    expect(page).to have_no_selector(:xpath, new_payment_xpath)
  end

end
