class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
end
