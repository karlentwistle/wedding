require "administrate/base_dashboard"

class PersonDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    food_choices: Field::HasMany,
    rsvp_code: Field::BelongsTo,
    foods: Field::HasMany,
    id: Field::Number,
    full_name: Field::String,
    attending_ceremony: Field::Boolean,
    attending_reception: Field::Boolean,
    dietary_requirements: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    child: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :food_choices,
    :rsvp_code,
    :foods,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :food_choices,
    :rsvp_code,
    :foods,
    :id,
    :full_name,
    :attending_ceremony,
    :attending_reception,
    :dietary_requirements,
    :created_at,
    :updated_at,
    :child,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :food_choices,
    :rsvp_code,
    :foods,
    :full_name,
    :attending_ceremony,
    :attending_reception,
    :dietary_requirements,
    :child,
  ].freeze

  # Overwrite this method to customize how people are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(person)
  #   "Person ##{person.id}"
  # end
end