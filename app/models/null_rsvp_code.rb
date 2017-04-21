class NullRsvpCode
  def secret
    ''
  end

  def ceremony
    false
  end

  def ceremony?
    ceremony
  end

  def reception
    false
  end

  def reception?
    reception
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
