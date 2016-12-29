require "rails_helper"

feature "Invoices:" do
  scenario "User can see a list of invoices, most recent first" do
    FactoryGirl.create(:invoice)
    FactoryGirl.create(:invoice, :paid)

    visit invoices_path

    within "#js-list-form" do
      expect(find(:xpath, ".//tbody/tr[1]")).to have_content "A-2"
      expect(find(:xpath, ".//tbody/tr[1]")).to have_content "paid"
      expect(find(:xpath, ".//tbody/tr[2]")).to have_content "A-1"
    end
  end
end
