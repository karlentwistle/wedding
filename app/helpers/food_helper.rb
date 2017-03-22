module FoodHelper
  def food_for_sitting(sitting, person)
    Food.for_sitting_and_person(sitting, person)
  end
end
