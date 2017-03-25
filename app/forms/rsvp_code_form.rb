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

  def viewable?
    !rsvp_code.responded?
  end

  def skip_to_end
    rsvp_code.responded? || RsvpCode.responded?(secret)
  end

  private

  def rsvp_code_exists
    unless RsvpCode.exists?(secret: secret)
      errors.add('secret', 'unfortunately your code wasn\'t found')
    end
  end

  attr_writer :secret
end
