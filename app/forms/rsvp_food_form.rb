class RsvpFoodForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  validate :validate_submitted_people

  def viewable?
    rsvp_code.persisted? && rsvp_code.respondable? && people.any?
  end

  def people
    @people ||= rsvp_code.people_attending_breakfast.tap do |people|
      people.each do |person|
        Food.sittings.values.each do |sitting_id|
          person.food_choices.find_or_initialize_by(sitting: sitting_id)
        end
      end
    end
  end

  def save
    if viewable? && valid?
      people
        .flat_map(&:food_choices)
        .each(&:save!)

      people.each(&:save!)

      true
    else
      false
    end
  end

  def valid?
    super && all_food_choices_valid?
  end

  def all_food_choices_valid?
    people
      .flat_map(&:food_choices)
      .map(&:valid?)
      .all? {|fc| fc == true}
  end

  def people_attributes=(attributes)
    attributes.to_h.each do |_, person_attributes|
      person = people.find(
        -> { raise ActiveRecord::RecordNotFound }
      ) do |person|
        person.id == person_attributes[:id].to_i
      end

      person.dietary_requirements = person_attributes[:dietary_requirements]

      person_attributes.fetch(:food_choices_attributes, {})
        .values
        .each.with_index do |food_choice, index|
          person.food_choices[index].food_id = food_choice[:food]
      end
    end
  end

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
