class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include RsvpCodeFetcher

  validate :validate_submitted_people

  def finish_early?
    people.where(attending: true).empty?
  end

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false

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
      person = people.find do |person|
        person.id == person_attributes[:id].to_i
      end

      if person
        person.attending = person_attributes[:attending]
      end
    end
  end

  private

  def submitted_people
    params
      .fetch(:people_attributes, {})
      .values
      .map do |params|
        people.find_by!(params.slice(:id))
      end
  end

  def validate_submitted_people
    if submitted_people.length < people.length
      errors.add(:base, 'a person is missing')
    end
  end
end
