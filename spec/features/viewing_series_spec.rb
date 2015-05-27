require 'rails_helper'

feature 'Viewing series' do
  scenario 'Listing all series' do
    series = FactoryGirl.create(:series)
    visit "/series"
    click_link "Example Series"
    expect(page.current_url).to eql(series_url(series))
  end
end
