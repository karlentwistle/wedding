class RsvpConfirmationForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false
  delegate :breakfast, to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    rsvp_code.persisted? && rsvp_code.responded?
  end

  def save
    true
  end
end
