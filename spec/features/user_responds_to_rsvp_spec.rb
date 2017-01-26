feature 'User responds to RSVP' do
  before do
    visit root_path
    within '.centered-navigation' do
      click_link 'RSVP'
    end
  end

  scenario 'no secret code entered' do
    click_button 'Next'
    expect(page).to have_content "can't be blank"
  end

  scenario 'their secret code cant be found' do
    fill_in 'Secret', with: '1234'
    click_button 'Next'
    expect(page).to have_content "unfortunately your code wasn't found"
  end
end
