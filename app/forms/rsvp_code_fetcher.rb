module RsvpCodeFetcher

  private

  def rsvp_code
    @rsvp_code ||= RsvpCode.find_by!(
      secret: cookies[:rsvp_code_secret]
    )
  end
end
