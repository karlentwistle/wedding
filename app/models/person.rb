class Person < ApplicationRecord
  validates :full_name, presence: true
  validates :rsvp_code, presence: true

  def to_s
    full_name
  end

  has_many :food_choices, -> { order(:sitting) }
  validates_associated :food_choices

  def food_choices_attributes=(*args); end

  Food.sittings.keys.each do |sitting|
    define_method("#{sitting}_choice") do
      foods.find_by(sitting: sitting)
    end
  end

  private

  belongs_to :rsvp_code
  has_many :foods, through: :food_choices
end
