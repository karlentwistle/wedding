class RsvpAttendanceForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include RsvpCodeFetcher

  validate :all_people_present

  def save
    if valid?
      Person.transaction do
        people_attributes.each do |_, attendance|
          person = people.find(attendance[:id])
          person.attending = attendance[:attending]
          person.save!
        end
      end

      true
    else
      false
    end
  end

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false

  attr_writer :people_attributes

  private

  def submitted_people
    @submitted_people ||= people.find(
      people_attributes.to_h.map do |_, attendance|
        attendance[:id]
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
