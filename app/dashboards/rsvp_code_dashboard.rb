require "administrate/base_dashboard"

class RsvpCodeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    people: UnlimitedHasManyField,
    id: Field::Number,
    secret: Field::String.with_options(searchable: false),
    ceremony: Field::Boolean,
    reception: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    responded: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :secret,
    :people,
    :ceremony,
    :reception,
    :responded,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :secret,
    :ceremony,
    :reception,
    :responded,
    :people,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :people,
    :secret,
    :ceremony,
    :reception,
  ].freeze

  def display_resource(rsvp_code)
    "RsvpCode ##{rsvp_code.id}"
  end
end
