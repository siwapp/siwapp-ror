require "rails_helper"

feature "Taxes" do

  scenario "User can delete a a tax", :js => true, :driver => :webkit do
    FactoryGirl.create(:tax)

    visit "/taxes/1/edit"

    click_link "Delete"

    expect(page.current_path).to eql(taxes_path)
    expect(page).to have_content("Tax was successfully deleted")
    expect(page).to have_no_content("VAT 21%")
  end

end
