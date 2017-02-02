require 'rails_helper'

feature 'User responds to breakfast RSVP' do
  before { visit_rsvp }

  let(:rsvp_code) { create(:rsvp_code, secret: '1234', breakfast: true, reception: true) }

  scenario 'valid secret code (1 invitee)
            Person A
              breakfast: false
              reception: false
            then redirected to confirmation page' do
    person_a = create(:person)
    rsvp_code.people << [person_a]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    submit_attendance({
      person_a => { breakfast: false, reception: false},
    })

    expect(page).to have_content "#{person_a.full_name} - breakfast: false, reception: false"
  end

  scenario 'valid secret code (2 invitees)
            Person A
              breakfast: false
              reception: false
            Person B
              breakfast: false
              reception: true
            then redirected to confirmation page' do
    person_a, person_b = create(:person), create(:person)
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { breakfast: false, reception: false},
      person_b => { breakfast: false, reception: true},
    })

    expect(page).to have_content "#{person_a.full_name} - breakfast: false, reception: false"
    expect(page).to have_content "#{person_b.full_name} - breakfast: false, reception: true"
  end

  scenario 'valid secret code (2 invitees)
            Person A
              breakfast: true
              reception: false
            Person B
              breakfast: false
              reception: true
            then select food choices for Person A only
            and redirected to confirmation page' do
    person_a, person_b = create(:person), create(:person)
    starter = create(:food, sitting: 0)
    main = create(:food, sitting: 1)
    dessert = create(:food, sitting: 2)

    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { breakfast: true, reception: false},
      person_b => { breakfast: false, reception: true},
    })

    submit_food_choices(
      person_a, {
        starter: starter,
        dietary_requirements: 'Gluten Free Meal'
      }
    )

    submit_food_choices(
      person_a, {
        main: main,
        dessert: dessert
      }
    )

    expect(page).to have_content "#{person_a.full_name} - breakfast: true, reception: false"
    expect(page).to have_content "#{person_b.full_name} - breakfast: false, reception: true"
  end
end
