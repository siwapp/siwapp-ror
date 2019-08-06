require "rails_helper"

feature "Templates:" do
  scenario "User can delete an existing template", :js => true, :driver => :webkit do
    template = FactoryBot.create(:print_template)
    visit edit_template_path(template)

    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eql templates_path
    expect(page).not_to have_content "Print Default"
  end
end
