class NullRsvpCode
  def secret
    ''
  end

  def breakfast
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

  def people_attending_breakfast
    []
  end

  def persisted?
    false
  end

  def responded?
    false
  end
end
