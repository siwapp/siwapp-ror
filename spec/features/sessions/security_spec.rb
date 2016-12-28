require "rails_helper"

feature "Sessions:" do

  scenario "Logged-in users can access protected routes" do
    # TODO: Add more routes
    visit invoices_path
    expect(page.current_path).to eql invoices_path
    visit root_path
    expect(page.current_path).to eql root_path
  end

  scenario "Logged-out users can't access protected routes" do
    first(:link, "Log out").click
    expect(page.current_path).to eql login_path
    visit invoices_path
    expect(page.current_path).to eql login_path # where are you going, sailor?
  end

end
