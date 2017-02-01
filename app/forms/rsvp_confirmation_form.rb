class RsvpConfirmationForm < RsvpBaseForm
  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false
  delegate :breakfast, to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    rsvp_code.persisted? && rsvp_code.responded?
  end
end
