class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false
  delegate :breakfast, to: :rsvp_code, prefix: false, allow_nil: false

  validate :validate_submitted_people

  def viewable?
    rsvp_code.persisted?
  end

  def finish_early?
    people.where(attending_breakfast: true).empty?
  end

  def save
    if valid?
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
      person.attending_breakfast = person_attributes[:attending_breakfast]
    end
  end

  private

  def submitted_people
    people_ids = params
      .fetch(:people_attributes, {})
      .values
      .map {|p| p[:id]}
      .compact

    people.where(id: people_ids)
  end

  def validate_submitted_people
    if submitted_people.count < people.count
      errors.add(:base, 'a person is missing')
    end
  end
end
