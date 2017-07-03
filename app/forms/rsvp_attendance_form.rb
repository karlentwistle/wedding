class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

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

  def valid?
    super && all_people_valid?
  end

  def all_people_valid?
    people.map(&:valid?).all? {|p| p == true}
  end

  def people_attributes=(people_attributes)
    people_attributes.to_h.each do |_, person_attributes|
      person = people.find(
        -> { raise ActiveRecord::RecordNotFound }
      ) do |person|
        person.id == person_attributes[:id].to_i
      end

      person.attending_reception = person_attributes[:attending_reception]
      person.attending_ceremony = person_attributes[:attending_ceremony]
    end
  end
end
