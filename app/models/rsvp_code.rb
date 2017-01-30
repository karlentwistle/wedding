class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
  has_many :people

  def to_s
    secret
  end

  def people_attending
    people.where(attending: true)
  end
end
