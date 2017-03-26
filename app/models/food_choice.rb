class FoodChoice < ApplicationRecord
  belongs_to :food, counter_cache: true
  belongs_to :person

  validates :sitting, uniqueness: { scope: [:person] }, presence: true
  validate :food_age_appropriacy

  enum sitting: Food.sittings.keys

  def food=(*args)
    super.tap { infer_sitting }
  end

  private

  def infer_sitting
    self.sitting = food.sitting if food
  end

  def food_age_appropriacy
    return unless food && person

    if food.child != person.child
      errors.add(:food, 'cannot be picked by person')
    end
  end
end
