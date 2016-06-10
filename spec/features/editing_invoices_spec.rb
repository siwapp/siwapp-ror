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
    # Done this way due to a weird error in the test. The button was
    # actually there but capybara can't click it because it says something is
    # overlapping it.
    page.execute_script("$('a.add_fields[data-association=item]').click();")
    # find('a.add_fields[data-association=item]').click

    # a new item appears
    new_item_xpath = "//*[@id='js-items-table']/div[4]"
    expect(page).to have_selector(:xpath, new_item_xpath)

    # Done this way due to a weird error in the test. The checkbox was
    # actually there but capybara does not find it if it's hidden.
    within :xpath, new_item_xpath do
      page.execute_script("$('.action-buttons').hide()");
      find('.tax-selector').find('.btn-group').find('.btn').click
      checkbox = find('.tax-selector').find('.btn-group').find('input[type="checkbox"][checked="checked"]')
      expect(checkbox.value.to_i).to eq default_tax.id
      page.execute_script("$('.action-buttons').show()");
    end
  end

  scenario 'Adding a payments to an Invoice', js: true, driver: :webkit do

    FactoryGirl.create(:invoice_unpaid, id: 3)
    visit "/invoices/3/edit"

    # click over "add payment",
    find('a.add_fields[data-association=payment]').click
    # a new payment appears ...
    new_payment_xpath = "//*[@id='js-payments-table']/div[2]"
    expect(page).to have_selector(:xpath, new_payment_xpath)

    within :xpath, new_payment_xpath do
      # default amount: what's left to pay. rounded with precision of 2
      expect(find('input[name*="amount"]').value.to_f).to eq 25.77
      # default date: today
      expect(find('input[name*="date"]').value).to eq Date.today.iso8601
    end

    # click over "remove payment"
    find(:xpath, "#{new_payment_xpath}//a[contains(@class, \"remove_fields\")]").click

    # ... the div is gone
    expect(page).to have_no_selector(:xpath, new_payment_xpath)
  end

  scenario 'Removing discounts to an Invoice', js: true, driver: :webkit do

    FactoryGirl.create(:invoice_unpaid, id: 3)
    visit "/invoices/3/edit"
    # there is a discount row
    expect(page).to have_selector '#amounts table tr', count: 5
    # we set every discount to zero
    all('input[name*="discount"]').each do |element|
      element.set '0.0'
     end
    # now there's no discount row
    expect(page).to have_selector '#amounts table tr', count: 4
  end

end
