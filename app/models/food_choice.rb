class FoodChoice < ApplicationRecord
  belongs_to :food
  belongs_to :person

  validates :sitting, uniqueness: { scope: [:person] }, presence: true

  enum sitting: Food.sittings.keys

  def food=(*args)
    super.tap { infer_sitting }
  end

  private

  def infer_sitting
    self.sitting = food.sitting if food
  end
end
