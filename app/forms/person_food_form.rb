class PersonFoodForm
  include ActiveModel::Validations

  validate :validate_food_choices

  def ==(other)
    other.class == self.class &&
    other.person == self.person
  end

  def initialize(person)
    @person = person
  end

  def food_choices_attributes=(params)
    params
      .values
      .each
      .with_index do |food_choice, index|
        person.food_choices[index].food_id = food_choice[:food]
      end
  end

  def save!
    person.save!
  end

  def update(params)
    params.each do |key, value|
      person.dietary_requirements = params[:dietary_requirements]
      self.food_choices_attributes = params.fetch(:food_choices_attributes, {})
    end
  end

  def build
    Food.sittings.values.each do |sitting_id|
      person.food_choices.find_or_initialize_by(sitting: sitting_id)
    end
  end

  delegate(
    :child,
    :dietary_requirements,
    :food_choices,
    :full_name,
    :id,
    :persisted?,
    to: :person,
    prefix: false,
    allow_nil: true
  )

  attr_reader :person

  private

  def validate_food_choices
    unless food_choices.map(&:valid?).all?
      errors.add(:base, 'invalid food')
    end
  end
end
