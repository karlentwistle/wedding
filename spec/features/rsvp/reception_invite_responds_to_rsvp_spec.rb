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
    person_a = create(:person, full_name: 'John Doe')
    person_b = create(:person, full_name: 'Jane Doe')
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)

    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { reception: false},
      person_b => { reception: true},
    })

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Reception: Can't make it"
      )
    end

    with_person(person_b) do
      expect(page).to have_content(
        "Jane Doe
        Reception: Attending"
      )
    end
  end
end
