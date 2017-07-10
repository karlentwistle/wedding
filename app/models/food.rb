class Food < ApplicationRecord
  validates :title, presence: true
  validates :sitting, presence: true
  enum sitting: [:starter, :main, :dessert]

  has_many :food_choices
  has_many :people, through: :food_choices

  def self.for_sitting_and_person(sitting, person)
    for_sitting(sitting).where(child: person.child)
  end

  def to_s
    title
  end

  private

  scope :for_sitting, -> (sitting) { where(sitting: sitting) }
end
