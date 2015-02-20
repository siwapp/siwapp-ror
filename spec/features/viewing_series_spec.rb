require 'rails_helper'

feature 'Viewing series' do
  scenario 'Listing all series' do
    serie = FactoryGirl.create(:serie)
    visit "/series"
    click_link "example serie"
    expect(page.current_url).to eql(serie_url(serie))
  end
end
