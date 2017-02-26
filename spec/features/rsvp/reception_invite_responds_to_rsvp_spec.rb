require 'rails_helper'

feature 'User responds to reception RSVP' do
  before { visit_rsvp }

  let(:rsvp_code) { create(:rsvp_code, secret: '1234', breakfast: false, reception: true) }

  scenario 'valid secret code (2 invitees)
            Person A
              reception: false
            Person B
              reception: true
            then redirected to confirmation page' do
    person_a, person_b = create(:person), create(:person)
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)

    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { reception: false},
      person_b => { reception: true},
    })

    expect(page).to have_content "#{person_a.full_name} - reception: false"
    expect(page).to have_content "#{person_b.full_name} - reception: true"
  end
end
