module FoodHelper

  def bootstrap_food!
    food
  end

  def food
    @_bootstrapped_food ||= {
      adult_starter: create_food(sitting: 'Starter'),
      child_starter: create_food(sitting: 'Starter', child: true),
      other_starter: create_food(sitting: 'Starter'),

      adult_main: create_food(sitting: 'Main'),
      child_main: create_food(sitting: 'Main', child: true),
      other_main: create_food(sitting: 'Main'),

      adult_dessert: create_food(sitting: 'Dessert'),
      child_dessert: create_food(sitting: 'Dessert', child: true),
      other_dessert: create_food(sitting: 'Dessert'),
    }
  end

  def create_food(title: nil, sitting: nil, child: false)
    basic_auth_admin
    visit '/admin/foods'
    click_link 'New food'

    random_food = build(:food)
    title = title || random_food.title
    sitting_name = sitting || random_food.sitting.humanize

    fill_in 'Title', with: title || random_food.title
    select sitting_name, from: 'Sitting'
    check 'Child' if child

    click_button 'Create Food'
    expect(page).to have_text('Food was successfully created.')

    Food.find_by!(title: title)
  end

  def food_options_for_select
    adult_starters = ['', food[:adult_starter]]
    adult_mains    = ['', food[:adult_main]]
    adult_desserts = ['', food[:adult_dessert]]

    child_starters = ['', food[:child_starter]]
    child_mains    = ['', food[:child_main]]
    child_desserts = ['', food[:child_dessert]]

    if food[:other_starter].child
      child_starters << food[:other_starter]
    else
      adult_starters << food[:other_starter]
    end

    if food[:other_main].child
      child_mains << food[:other_main]
    else
      adult_mains << food[:other_main]
    end

    if food[:other_dessert].child
      child_desserts << food[:other_dessert]
    else
      adult_desserts << food[:other_dessert]
    end

    {
      adult_starters: adult_starters.map(&:to_s),
      child_starters: child_starters.map(&:to_s),

      adult_mains: adult_mains.map(&:to_s),
      child_mains: child_mains.map(&:to_s),

      adult_desserts: adult_desserts.map(&:to_s),
      child_desserts: child_desserts.map(&:to_s),
    }
  end
end

RSpec.configure do |config|
  config.include FoodHelper, :type => :feature
end
