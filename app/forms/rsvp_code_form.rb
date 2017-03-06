class RsvpCodeForm < RsvpBaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  validates :secret, presence: true
  validate :rsvp_code_exists

  def save
    valid?
  end

  attr_reader :secret

  def cookie_payload
    { rsvp_code_secret: secret }
  end

  def finish_early?
    RsvpCode.exists?(secret: secret, responded: true)
  end

  private

  def rsvp_code_exists
    unless RsvpCode.exists?(secret: secret)
      errors.add('secret', 'unfortunately your code wasn\'t found')
    end
  end

  attr_writer :secret
end
