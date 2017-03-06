class RsvpConfirmationForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  delegate :people,
           :breakfast,
           :respondable?,
           to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    rsvp_code.persisted? && rsvp_code.confirmable?
  end

  def save
    rsvp_code.close
  end
end
