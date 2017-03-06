module RsvpHelper
  def visit_rsvp
    visit root_path

    within '.centered-navigation' do
      click_link 'RSVP'
    end
  end

  def submit_code(secret=nil)
    fill_in I18n.t('rsvp.step.label'), with: secret if secret
    click_button 'Next'
  end

  def submit_attendance(opts={})
    opts.each do |person, attending_choices|
      with_person(person) do
        check 'Attending breakfast' if attending_choices.fetch(:breakfast, false)
        check 'Attending reception' if attending_choices.fetch(:reception, false)
      end
    end

    click_button 'Next'
  end

  def with_person(person)
    within("div[data-id=\"#{person.id}\"]") do
      yield
    end
  end

  def submit_food_choices(person, opts={})
    food_opts = opts
      .slice(:starter, :main, :dessert)
      .select{|k,v| v.present?}

    dietary_requirements = opts[:dietary_requirements]

    within("div[data-id=\"#{person.id}\"]") do
      food_opts.each do |label, food|
        page.select(food.title, from: label.to_s.titlecase)
      end

      if dietary_requirements.present?
        fill_in 'Dietary requirements', with: dietary_requirements
      end
    end

    click_button 'Next'
  end

  def confirm_rsvp
    click_button I18n.t('rsvp.button.confirm')
    expect(page).to have_content(I18n.t('rsvp.flash.success'))
  end
end

RSpec.configure do |config|
  config.include RsvpHelper, :type => :feature
end
