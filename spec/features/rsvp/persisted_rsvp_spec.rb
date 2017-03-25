require 'rails_helper'

feature 'An RSVP code is persisted between sessions' do
  let(:rsvp_code) {
    create(:rsvp_code,
      secret: '1234',
      ceremony: false,
      reception: true
    )
  }
  let(:person) { create(:person, full_name: 'John Doe') }
  before { rsvp_code.people << person }

  scenario 'a person responds to their RSVP via the flow
            they confirm their rsvp
            they navigate away from the website
            they revist the website and navigate back to RSVP flow' do
    visit_rsvp
    submit_code(rsvp_code)
    submit_attendance({
      person => { reception: true},
    })

    with_person(person) do
      expect(page).to have_content(
        "John Doe Reception: Attending"
      )
    end

    confirm_rsvp
    visit_information
    visit_rsvp
    with_person(person) do
      expect(page).to have_content(
        "John Doe Reception: Attending"
      )
    end
  end
end
