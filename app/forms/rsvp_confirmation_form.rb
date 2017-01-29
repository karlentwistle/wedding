class RsvpConfirmationForm < RsvpBaseForm
  include RsvpCodeFetcher

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false
end
