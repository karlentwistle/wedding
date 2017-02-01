require 'rails_helper'

feature 'User responds to RSVP' do
  before { visit_rsvp }

  scenario 'no secret code entered' do
    submit_code
    expect(page).to have_content "can't be blank"
  end

  scenario 'secret code cant be found' do
    submit_code('1234')
    expect(page).to have_content "unfortunately your code wasn't found"
  end
end
