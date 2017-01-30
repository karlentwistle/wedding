module FoodHelper
  def food_for_sitting(sitting)
    all_food.select {|food| food.sitting == sitting}
  end

  private

  def all_food
    @all_food ||= Food.all
  end
end
