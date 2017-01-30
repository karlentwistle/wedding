class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include RsvpCodeFetcher

  validate :all_people_present

  def finish_early?
    people.where(attending: true).empty?
  end

  def save
    if valid?
      Person.transaction do
        people_attributes.each do |_, person_attributes|
          person = people.find(person_attributes[:id])
          person.attending = person_attributes[:attending]
          person.save!
        end
      end

      true
    else
      false
    end
  end

  delegate :people, :people_attending, to: :rsvp_code, prefix: false, allow_nil: false

  attr_writer :people_attributes

  private

  def submitted_people
    @submitted_people ||= people.find(
      people_attributes.to_h.map do |_, person_attributes|
        person_attributes[:id]
      end
    )
  end

  def all_people_present
    return true if submitted_people == people
    missing_person if submitted_people.count < people.count
  end

  def missing_person
    errors.add(:base, 'a person is missing')
    false
  end

  attr_reader :people_attributes
end
