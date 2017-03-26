require 'rails_helper'

feature 'User responds to ceremony RSVP' do
  let(:rsvp_code) { create(:rsvp_code, secret: '1234', ceremony: true, reception: true) }

  scenario 'valid secret code (1 invitee)
            Person A
              ceremony: false
              reception: false
            then redirected to confirmation page
            cannot alter their RSVP afterwards' do
    person_a = create(:person, full_name: 'John Doe')
    rsvp_code.people << [person_a]

    visit_rsvp
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

    using_session('another computer') do
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

    visit_rsvp
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
              reception: true
            Child A
              ceremony: true
              reception: true' do
    person_a = create(:person, full_name: 'John Doe')
    child_a = create(:person, full_name: 'Little Johnny Doe', child: true)
    rsvp_code.people << [person_a, child_a]
    bootstrap_food!

    visit_rsvp
    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content child_a.full_name
    submit_attendance({
      person_a => { ceremony: true, reception: true},
      child_a => { ceremony: true, reception: true},
    })

    with_person(person_a) do
      expect(options_for_select('Starter'))
        .to match_array(food_options_for_select[:adult_starters])

      expect(options_for_select('Main'))
        .to match_array(food_options_for_select[:adult_mains])

      expect(options_for_select('Dessert'))
        .to match_array(food_options_for_select[:adult_desserts])
    end

    with_person(child_a) do
      expect(options_for_select('Starter'))
        .to match_array(food_options_for_select[:child_starters])

      expect(options_for_select('Main'))
        .to match_array(food_options_for_select[:child_mains])

      expect(options_for_select('Dessert'))
        .to match_array(food_options_for_select[:child_desserts])
    end

    submit_food_choices(
      person_a, {
        starter: food[:adult_starter],
        main: food[:adult_main],
        dessert: food[:adult_dessert]
      },
    )

    submit_food_choices(
      child_a, {
        starter: food[:child_starter],
        main: food[:child_main],
        dessert: food[:child_dessert]
      }
    )

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Attending
        Starter: #{food[:adult_starter]}
        Main: #{food[:adult_main]}
        Dessert: #{food[:adult_dessert]}
        Reception: Attending"
      )
    end

    with_person(child_a) do
      expect(page).to have_content(
        "Little Johnny Doe
        Ceremony: Attending
        Starter: #{food[:child_starter]}
        Main: #{food[:child_main]}
        Dessert: #{food[:child_dessert]}
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
    bootstrap_food!

    visit_rsvp
    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance({
      person_a => { ceremony: true, reception: false},
      person_b => { ceremony: false, reception: true},
    })

    submit_food_choices(
      person_a, {
        starter: food[:adult_starter],
        dietary_requirements: 'Gluten Free Meal'
      }
    )

    submit_food_choices(
      person_a, {
        main: food[:adult_main],
        dessert: food[:adult_dessert]
      }
    )

    with_person(person_a) do
      expect(page).to have_content(
        "John Doe
        Ceremony: Attending
        Starter: #{food[:adult_starter]}
        Main: #{food[:adult_main]}
        Dessert: #{food[:adult_dessert]}
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

  def options_for_select(label)
    find(:select, label).all(:option).map(&:text)
  end
end
