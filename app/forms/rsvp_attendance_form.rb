require_relative '../../lib/fake_collection_proxy'

class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  validate :validate_people

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false
  delegate :ceremony, :reception, to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    rsvp_code.persisted? && rsvp_code.respondable?
  end

  def save
    if viewable? && valid?
      people.each(&:save!)

      true
    else
      false
    end
  end

  def people_attributes=(people_attributes)
    people_attributes.to_h.each do |_, person_attributes|
      find_person_or_raise(person_attributes[:id])
        .attributes = {
          attending_reception: person_attributes[:attending_reception],
          attending_ceremony: person_attributes[:attending_ceremony]
        }
    end
  end

  private

  def find_person_or_raise(id)
    FakeCollectionProxy[*people].find do |person|
      person.id == id.to_i
    end
  end

  def validate_people
    unless people.map(&:valid?).all?
      error.add(:base, 'invalid person')
    end
  end
end
