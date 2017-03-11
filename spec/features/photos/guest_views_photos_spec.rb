require 'rails_helper'

feature 'User views photos' do
  before { visit_photos }

  scenario 'navigates to photo page sees three photos' do
    within '.cards' do
      expect(page).to have_css('img', count: 3)
    end
  end
end


