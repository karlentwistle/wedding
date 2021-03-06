require "administrate/base_dashboard"

class FoodDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    sitting: Field::Select.with_options(
      collection: Food.sittings.keys,
      searchable: false,
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    child: Field::Boolean,
    people: Field::HasMany.with_options(limit: 100),
    food_choices_count: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :sitting,
    :food_choices_count,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :sitting,
    :child,
    :food_choices_count,
    :people,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :sitting,
    :child,
  ].freeze

  # Overwrite this method to customize how foods are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(food)
    food.title
  end
end
