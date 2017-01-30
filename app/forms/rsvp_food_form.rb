class RsvpFoodForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include RsvpCodeFetcher

  validate :all_submitted_people_belong_to_rsvp

  def viewable?
    people.any?
  end

  def people
    @people ||= rsvp_code.people_attending.each do |person|
      person.food_choices.find_or_initialize_by(sitting: 0)
      person.food_choices.find_or_initialize_by(sitting: 1)
      person.food_choices.find_or_initialize_by(sitting: 2)
    end
  end

  def save
    if valid?
      people
        .flat_map(&:food_choices)
        .each(&:save!)

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
      person = people.find do |person|
        person.id == person_attributes[:id].to_i
      end

      person_attributes.fetch(:food_choices_attributes, {})
        .values
        .each.with_index do |food_choice, index|
          person.food_choices[index].food_id = food_choice[:food]
      end
    end
  end

  def all_submitted_people_belong_to_rsvp
    params
      .fetch(:people_attributes, {})
      .values
      .each do |params|
        rsvp_code
          .people
          .find_by!(params.slice(:id))
    end
  end
end
