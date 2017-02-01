class RsvpConfirmationForm < RsvpBaseForm
  include RsvpCodeFetcher

  delegate :people, to: :rsvp_code, prefix: false, allow_nil: false

  def viewable?
    !people.map(&:attending_breakfast).any?(&:nil?)
  end
end
