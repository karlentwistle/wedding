class Person < ApplicationRecord
  validates :full_name, presence: true

  after_save :destroy_food_choices, unless: :attending_ceremony

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

  def invited_to_ceremony?
    rsvp_code.ceremony?
  end

  def invited_to_reception?
    rsvp_code.reception?
  end

  def responded?
    rsvp_code.responded?
  end

  belongs_to :rsvp_code, optional: true

  def rsvp_code
    super || NullRsvpCode.new
  end

  private

  def destroy_food_choices
    food_choices.destroy_all if food_choices.any?
  end

  has_many :foods, through: :food_choices
end
