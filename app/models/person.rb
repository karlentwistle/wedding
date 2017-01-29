class Person < ApplicationRecord
  validates :full_name, presence: true
  validates :rsvp_code, presence: true

  belongs_to :rsvp_code

  def to_s
    full_name
  end
end
