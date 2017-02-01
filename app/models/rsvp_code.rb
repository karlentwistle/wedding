class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
  has_many :people

  def to_s
    secret
  end

  def people_attending_breakfast
    people.where(attending_breakfast: true)
  end
end
