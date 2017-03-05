class Person < ApplicationRecord
  validates :full_name, presence: true
  validates :rsvp_code, presence: true

  after_save :destroy_food_choices, unless: :attending_breakfast

  def to_s
    full_name
  end

  has_many :food_choices, -> { order(:sitting) }

  def food_choices_attributes=(*args); end

  Food.sittings.keys.each do |sitting|
    define_method("#{sitting}_choice") do
      foods.find_by(sitting: sitting)
    end
  end

  def invited_to_breakfast?
    return false unless rsvp_code
    rsvp_code.breakfast
  end

  private

  def destroy_food_choices
    food_choices.destroy_all if food_choices.any?
  end

  belongs_to :rsvp_code
  has_many :foods, through: :food_choices
end
