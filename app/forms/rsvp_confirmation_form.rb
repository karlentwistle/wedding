class RsvpConfirmationForm < RsvpBaseForm
  include RsvpCodeFetcher

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    !people.map(&:attending).any?(&:nil?)
  end
end
