class RsvpBaseForm
  def persisted?
    false
  end

  def initialize(rsvp_code: nil, params: {})
    @rsvp_code = rsvp_code
    @params = params
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def viewable?
    true
  end

  def skip_to_end
    false
  end

  def save
    raise NotImplementedError, 'Sorry, you have to override save'
  end

  def cookie_payload
    {}
  end

  private

  attr_reader :rsvp_code, :params
end
