module FoodHelper

  def bootstrap_food!
    food
  end

  def food
    @_bootstrapped_food ||= {
      adult_starter: create(:food, sitting: 0),
      child_starter: create(:food, sitting: 0, child: true),
      other_starter: create(:food, sitting: 0),

      adult_main: create(:food, sitting: 1),
      child_main: create(:food, sitting: 1, child: true),
      other_main: create(:food, sitting: 1),

      adult_dessert: create(:food, sitting: 2),
      child_dessert: create(:food, sitting: 2, child: true),
      other_dessert: create(:food, sitting: 2),
    }
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
