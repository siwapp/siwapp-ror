require "rails_helper"

feature "Templates:" do
  scenario "User can create a new template", :js => true, :driver => :webkit do
    visit templates_path
    click_on "New Template"

    expect(page.current_path).to eql new_template_path

    fill_in "template_name", with: "My Awesome Template"
    fill_in "template_template", with: "Hello"

    click_on "Save"

    expect(page.current_path).to eql templates_path
    expect(page).to have_content "My Awesome Template"
  end

  scenario "User can't create a new template with invalid data", :js => true, :driver => :webkit do
    visit new_template_path

    fill_in "template_name", with: "My Awesome Template"
    click_on "Save"

    expect(page.current_path).to eql templates_path
    expect(page).to have_content "1 error"
  end
end
