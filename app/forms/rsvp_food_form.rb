class RsvpFoodForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  validate :validate_people

  def viewable?
    rsvp_code.persisted? && rsvp_code.respondable? && people.any?
  end

  def skip_to_end
    rsvp_code.people_all_rejected_ceremony
  end

  def people
    @people ||= rsvp_code.people_attending_ceremony.flat_map do |person|
      PersonFoodForm.new(person).tap do |person_form|
        person_form.build
      end
    end
  end

  def save
    if viewable? && valid?
      people.each(&:save!)

      true
    else
      false
    end
  end

  def people_attributes=(attributes)
    attributes.to_h.each do |_, person_attributes|
      person = people.find(
        -> { raise ActiveRecord::RecordNotFound }
      ) do |person|
        person.id == person_attributes[:id].to_i
      end
      person.update(person_attributes)
    end
  end

  def validate_people
    unless people.map(&:valid?).all?
      errors.add(:base, 'invalid person')
    end
  end
end
