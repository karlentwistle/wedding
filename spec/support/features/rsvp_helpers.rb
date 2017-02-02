module RsvpHelper
  def visit_rsvp
    visit root_path

    within '.centered-navigation' do
      click_link 'RSVP'
    end
  end

  def submit_code(secret=nil)
    fill_in 'Secret', with: secret if secret
    click_button 'Next'
  end

  def submit_attendance(opts={})
    opts.each do |person, attending_choices|
      within("div[data-id=\"#{person.id}\"]") do
        check 'Attending breakfast' if attending_choices.fetch(:breakfast, false)
        check 'Attending reception' if attending_choices.fetch(:reception, false)
      end
    end

    click_button 'Next'
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
end

RSpec.configure do |config|
  config.include RsvpHelper, :type => :feature
end
