class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
  validates :breakfast, inclusion: { in: [true, false] }
  validates :reception, inclusion: { in: [true, false] }

  validate :invited_to_something

  has_many :people

  def to_s
    secret
  end

  def people_attending_breakfast
    people.where(attending_breakfast: true)
  end

  private

  def invited_to_something
    unless breakfast || reception
      errors.add(:base, 'must invite people to something')
    end
  end
end
