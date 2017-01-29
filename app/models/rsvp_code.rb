class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
  has_many :people

  def to_s
    secret
  end
end
