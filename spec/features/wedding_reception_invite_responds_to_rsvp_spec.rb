require 'rails_helper'

feature 'User responds to RSVP' do
  before do
    visit root_path
    within '.centered-navigation' do
      click_link 'RSVP'
    end
  end

  scenario 'no secret code entered' do
    submit_code
    expect(page).to have_content "can't be blank"
  end

  scenario 'their secret code cant be found' do
    submit_code('1234')
    expect(page).to have_content "unfortunately your code wasn't found"
  end

  scenario 'their secret code is correct some can attend some cant' do
    rsvp_code = create(:rsvp_code, secret: '1234')
    person_a = create(:person)
    person_b = create(:person)
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({person_a => true, person_b => false})
    expect(page).to have_content "#{person_a.full_name} - true"
    expect(page).to have_content "#{person_b.full_name} - false"
  end

  def submit_code(secret=nil)
    fill_in 'Secret', with: secret if secret
    click_button 'Next'
  end

  def submit_attendance(people)
    people.each do |person, attending|
      within("div[data-id=\"#{person.id}\"]") do
        check 'Attending' if attending
      end
    end

    click_button 'Next'
  end
end
