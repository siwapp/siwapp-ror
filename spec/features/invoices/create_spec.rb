require "rails_helper"

feature "Invoices:" do

  scenario "User can create an invoice. A customer is created.", :js => true, :driver => :webkit do
    FactoryGirl.create(:b_series)
    FactoryGirl.create(:invoice, :paid)

    visit new_invoice_path

    fill_in "invoice_name", with: "Another Test Customer"
    fill_in "invoice_identification", with: "54321"
    fill_in "invoice_email", with: "another@customer.com"
    fill_in "invoice_invoicing_address", with: "Fake Address"

    click_link "Copy Invoicing Address"
    expect(find_field("invoice_shipping_address").value).to eq "Fake Address"

    fill_in "Issue date", with: Date.current
    fill_in "Due date", with: Date.current >> 1

    # Fill in the only item line available via autocomplete
    within(:xpath, '//*[@id="js-items-table"]/div[1]') do
      fill_in "Description", with: "Invoicing"
    end

    find(".ui-menu-item", :text => "Invoicing App Development - $ 10,000").click

    within(:xpath, '//*[@id="js-items-table"]/div[1]') do
      expect(find_field("Quantity").value).to eq "1.0"
      expect(find_field("Price").value).to eq "10000.0"

      # Check that taxes selector works for the default item...
      within ".invoice-col--taxes" do
        find("label").click
      end
    end

    # ... by adding VAT
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    click_on "Add Line"

    # Fill in the new item line created
    within(:xpath, '//*[@id="js-items-table"]/div[2]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Check that taxes selector works for the new item
      within ".invoice-col--taxes" do
        find("label").click
      end
    end

    # ... by adding VAT
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    expect(page).to have_content "$ 12,160.50"

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content("Invoice was successfully created.")
    expect(page).to have_content "A-2"
    expect(page).to have_content "$ 12,160.50"

    expect(Customer.find_by(email: "another@customer.com", identification: "54321")).not_to be nil
  end

  scenario "User can choose an existing customer via autocomplete", :js => true, :driver => :webkit do
    FactoryGirl.create_list(:ncustomer, 5)

    visit new_invoice_path

    fill_in "Name", with: "hou"
    find(".ui-menu-item", :text => "Warehousing").click

    # and we should have data filled
    expect(find_field("invoice_name").value).to eq "Warehousing"
    expect(find_field("invoice_email").value).to eq "info@warehousing.com"
  end

  scenario "User can't create an invoice with no customer data or series", :js => true, :driver => :webkit do
    visit new_invoice_path
    click_on "Save"

    expect(page).to have_content "2 errors"
  end

  scenario "Saving a draft", :js => true, :driver => :webkit do
    FactoryGirl.create(:series, :default)

    visit new_invoice_path

    fill_in "invoice_name", with: "Another Test Customer"
    fill_in "invoice_identification", with: "54321"
    fill_in "invoice_email", with: "another@customer.com"
    fill_in "invoice_invoicing_address", with: "Fake Address"

    check "invoice_draft"

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content("Invoice was successfully created.")
    expect(page).to have_content "A-[draft]"
  end
end
