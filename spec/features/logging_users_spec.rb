require 'rails_helper'

feature 'Creating Invoices' do

  before do
    FactoryGirl.create :user
  end

  scenario 'can log in' do
    visit '/login'
    fill_in 'Email', with: 'testuser@example.org'
    fill_in 'Password', with: 'testuser'
    click_on 'Log in'
    expect(page.current_path).to eql invoices_path
  end
end
