require "rails_helper"

feature "Recurring Invoices:" do
  scenario "User can update a recurring invoice", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)

    visit edit_recurring_invoice_path(recurring_invoice)
    fill_in "recurring_invoice_days_to_due", with: "20"
    click_on "Save"

    expect(page).to have_content "successfully updated"
  end

  scenario "User can't update a recurring invoice with invalid data", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)

    visit edit_recurring_invoice_path(recurring_invoice)
    fill_in "recurring_invoice_period", with: ""
    click_on "Save"

    expect(page.current_path).to eql recurring_invoice_path(recurring_invoice)
    expect(page).to have_content "2 errors" # blank, not number
  end

  scenario "User can add a new item to an existing recurring invoice", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)
    visit edit_recurring_invoice_path(recurring_invoice)
    click_on "Add Line"

    within(:xpath, '//*[@id="js-items-table"]/div[2]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Display taxes selector
      within ".invoice-col--taxes" do
        find("label").click
      end
    end

    # Select VAT tax
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    expect(page).to have_content "$ 10,660.50"

    click_on "Save"
    # TODO Make these tests to work. They stopped working
    # when redirecting to index with last search
    expect(page.current_path).to eql recurring_invoices_path
    expect(page).to have_content("successfully updated")
    expect(page).to have_content "$ 10,660.50"
  end
end
