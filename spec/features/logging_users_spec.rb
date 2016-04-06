require 'rails_helper'

feature 'Logged users' do

  before do
    FactoryGirl.create :user
    visit '/login'
    fill_in 'Email', with: 'testuser@example.org'
    fill_in 'Password', with: 'testuser'
    click_on 'Log in'
    expect(page.current_path).to eql invoices_path
  end

  scenario 'can access anywhere' do
    visit '/customers'
    expect(page.current_path).to eql customers_path
    visit '/recurring_invoices'
    expect(page.current_path).to eql recurring_invoices_path
    visit '/'
    expect(page.current_path).to eql root_path
  end

  scenario 'and of course can log out' do
    click_on 'Log out'
    expect(page.current_path).to eql login_path
    visit '/invoices'
    expect(page.current_path).to eql login_path # where are you going, sailor?
  end

end
