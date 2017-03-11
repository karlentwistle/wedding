class NullRsvpCode
  def secret
    ''
  end

  def ceremony
    false
  end

  def reception
    true
  end

  def people
    []
  end

  def to_s
    secret
  end

  def people_attending_ceremony
    []
  end

  def persisted?
    false
  end

  def responded?
    false
  end
end
