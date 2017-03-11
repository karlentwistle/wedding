require 'rails_helper'

feature 'User responds to ceremony RSVP' do
  before { visit_rsvp }

  let(:rsvp_code) { create(:rsvp_code, secret: '1234', ceremony: true, reception: true) }

  scenario 'valid secret code (1 invitee)
            Person A
              ceremony: false
              reception: false
            then redirected to confirmation page
            cannot alter their RSVP afterwards' do
    person_a = create(:person, full_name: 'John Doe')
    rsvp_code.people << [person_a]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    submit_attendance({
      person_a => { ceremony: false, reception: false},
    })

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Can't make it
        Reception: Can't make it"
      )
    end

    confirm_rsvp
    visit_rsvp
    submit_code(rsvp_code)
    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Can't make it
        Reception: Can't make it"
      )
    end
  end

  scenario 'valid secret code (2 invitees)
            Person A
              ceremony: false
              reception: false
            Person B
              ceremony: false
              reception: true
            then redirected to confirmation page' do
    person_a = create(:person, full_name: 'John Doe')
    person_b = create(:person, full_name: 'Jane Doe')
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { ceremony: false, reception: false},
      person_b => { ceremony: false, reception: true},
    })

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Can't make it
        Reception: Can't make it"
      )
    end

    with_person(person_b) do
      expect(page).to have_content(
        "Jane Doe
        Ceremony: Can't make it
        Reception: Attending"
      )
    end
  end

  scenario 'valid secret code (2 invitees)
            Person A
              ceremony: true
              reception: false
            Person B
              ceremony: false
              reception: true
            then select food choices for Person A only
            and redirected to confirmation page' do
    person_a = create(:person, full_name: 'John Doe')
    person_b = create(:person, full_name: 'Jane Doe')
    rsvp_code.people << [person_a, person_b]

    starter = create(:food, sitting: 0, title: 'Calamari')
    other_starter = create(:food, sitting: 0)

    main = create(:food, sitting: 1, title: 'Kokam')
    other_main = create(:food, sitting: 1)

    dessert = create(:food, sitting: 2, title: 'Nashi Pear')
    other_dessert = create(:food, sitting: 2)

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { ceremony: true, reception: false},
      person_b => { ceremony: false, reception: true},
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

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Attending
        Starter: Calamari
        Main: Kokam
        Dessert: Nashi Pear
        Dietary Requirements: Gluten Free Meal
        Reception: Can't make it"
      )
    end

    with_person(person_b) do
      expect(page).to have_content(
        "Jane Doe
        Ceremony: Can't make it
        Reception: Attending"
      )
    end
  end
end
