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

  scenario 'their secret code is correct
            they mark all guests not attending_breakfast
            they select food for the guests that are attending_breakfast
            and are redirected to confirmation page' do
    rsvp_code = create(:rsvp_code, secret: '1234')
    person_a, person_b = create(:person), create(:person)
    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance(
      {person_a => false, person_b => false}
    )

    expect(page).to have_content "#{person_a.full_name} - false"
    expect(page).to have_content "#{person_b.full_name} - false"
  end

  scenario 'their secret code is correct
            they mark some guests as attending_breakfast some not attending_breakfast
            they select food for the guests that are attending_breakfast
            and are redirected to confirmation page' do
    rsvp_code = create(:rsvp_code, secret: '1234')
    person_a, person_b = create(:person), create(:person)
    starter = create(:food, sitting: 0)
    main = create(:food, sitting: 1)
    dessert = create(:food, sitting: 2)

    rsvp_code.people << [person_a, person_b]

    submit_code(rsvp_code)
    expect(page).to have_content person_a.full_name
    expect(page).to have_content person_b.full_name
    submit_attendance(
      {person_a => true, person_b => false}
    )

    submit_food_choices({
      person_a => {
        'Starter': starter,
      }
    })

    submit_food_choices({
      person_a => {
        'Main': main,
        'Dessert': dessert
      }
    })

    expect(page).to have_content "#{person_a.full_name} - true"
    expect(page).to have_content "#{person_b.full_name} - false"
  end

  def submit_code(secret=nil)
    fill_in 'Secret', with: secret if secret
    click_button 'Next'
  end

  def submit_attendance(people)
    people.each do |person, attending_breakfast|
      within("div[data-id=\"#{person.id}\"]") do
        check 'Attending breakfast' if attending_breakfast
      end
    end

    click_button 'Next'
  end

  def submit_food_choices(opts={})
    opts.each do |person, food_choices|
      within("div[data-id=\"#{person.id}\"]") do
        food_choices.each do |label, food|
          page.select(food.title, from: label)
        end
      end
    end

    click_button 'Next'
  end

end
