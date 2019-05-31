require "rails_helper"

feature "Invoices:" do
  background do
    Rails.application.load_seed

    @unpaid_invoice = FactoryBot.create(:invoice)              # 3
    @paid_invoice = FactoryBot.create(:invoice, :paid)         # 2
    @draft_invoice = FactoryBot.create(:invoice, draft: true)  # 1
  end

  scenario "User can see a list of invoices, most recent first", :js => true, :driver => :webkit do
    visit invoices_path

    within "#js-list-form" do
      expect(find(:xpath, ".//tbody/tr[1]")).to have_content "A-[draft]"
      expect(find(:xpath, ".//tbody/tr[2]")).to have_content "A-2"
      expect(find(:xpath, ".//tbody/tr[2]")).to have_content "paid"
      expect(find(:xpath, ".//tbody/tr[3]")).to have_content "A-1"
    end
  end

  scenario "User gets redirected to edit page after clicking on an unpaid invoice", :js => true, :driver => :webkit do
    visit invoices_path
    find(:xpath, ".//tbody/tr[3]").click
    expect(page.current_path).to eql edit_invoice_path(@unpaid_invoice)
  end

  scenario "User gets redirected to preview page after clicking on a paid invoice", :js => true, :driver => :webkit do
    visit invoices_path
    find(:xpath, ".//tbody/tr[2]").click
    expect(page.current_path).to eql invoice_path(@paid_invoice)
  end

  scenario "User can delete all invoices at the same time", :js => true, :driver => :webkit do
    visit invoices_path

    find_field('select_all').click
    expect(page).to have_checked_field('invoice_ids[]', :count => 3)

    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eql invoices_path
    expect(Invoice.count).to eql 0
  end

  scenario "User can mark invoices as paid from the invoices list", :js => true, :driver => :webkit do
    visit invoices_path

    find_field('select_all').click
    click_on "Set Paid"

    expect(page).to have_content "Successfully set as paid 1 invoices."
  end
end
