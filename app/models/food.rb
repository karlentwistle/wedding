class Food < ApplicationRecord
  validates :title, presence: true
  validates :sitting, presence: true
  enum sitting: [:starter, :main, :dessert]

  def to_s
    title
  end
end
