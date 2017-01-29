class RsvpBaseForm
  def persisted?
    false
  end

  def initialize(cookies: nil, params: {})
    @cookies = cookies
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def save
    raise NotImplementedError, 'Sorry, you have to override save'
  end

  def cookie_payload
    {}
  end

  private

  attr_reader :cookies
end
