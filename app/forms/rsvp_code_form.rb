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

  private

  def rsvp_code_exists
    if secret.present? && RsvpCode.exists?(secret: secret)
      return true
    elsif secret.present?
      errors.add('secret', 'unfortunately your code wasn\'t found')
      false
    else
      false
    end
  end

  attr_writer :secret
end
