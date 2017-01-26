class RsvpCodeForm
  include ActiveModel::Model

  def persisted?
    false
  end

  def initialize(params={})
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  validates :secret, presence: true
  validate :rsvp_code_exists

  def save
    valid?
  end

  attr_reader :secret

  private

  def rsvp_code_exists
    if secret.present? && RsvpCode.exists?(secret: secret)
      true
    elsif secret.present?
      errors.add('secret', 'unfortunately your code wasn\'t found')
      false
    else
      false
    end
  end

  attr_writer :secret
end


