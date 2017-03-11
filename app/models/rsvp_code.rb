class RsvpCode < ApplicationRecord
  validates :secret, presence: true, uniqueness: true
  validates :ceremony, inclusion: { in: [true, false] }
  validates :reception, inclusion: { in: [true, false] }

  validate :invited_to_something

  has_many :people

  def to_s
    secret
  end

  def close
    update_attributes!(responded: true)
  end

  def respondable?
    !responded
  end

  def confirmable?
    return false unless people.present?

    if ceremony?
      people.where(
        attending_ceremony: nil,
        attending_reception: nil
      ).empty?
    elsif reception?
      people.where(
        attending_reception: nil
      ).empty?
    end
  end

  def people_attending_ceremony
    people.where(attending_ceremony: true)
  end

  private

  def invited_to_something
    unless ceremony || reception
      errors.add(:base, 'must invite people to something')
    end
  end
end
