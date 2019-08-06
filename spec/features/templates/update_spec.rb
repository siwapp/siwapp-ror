require "rails_helper"

feature "Templates:" do
  scenario "User can update an existing template", :js => true, :driver => :webkit do
    template = FactoryBot.create(:print_template)

    visit templates_path
    click_on "Print Default"

    expect(page.current_path).to eql edit_template_path(template)

    fill_in "template_name", with: "My Awesome Template (modified)"
    fill_in "template_template", with: "Hello (modified)"
    click_on "Save"

    expect(page.current_path).to eql templates_path
    expect(page).to have_content "My Awesome Template (modified)"
  end

  scenario "User can't update an existing template with invalid data", :js => true, :driver => :webkit do
    template = FactoryBot.create(:print_template)

    visit edit_template_path(template)

    fill_in "template_name", with: ""
    click_on "Save"

    expect(page.current_path).to eql template_path(template)
    expect(page).to have_content "1 error"
  end
end
