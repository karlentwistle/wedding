class PersonStatistics
  def person_count
    @person_count ||= Person.count
  end

  def responded_count
    @responded_count ||= Person.joins(:rsvp_code).where(rsvp_codes: {responded: true}).count
  end

  def ceremony_count
    @ceremony_count ||= Person.where(attending_ceremony: true).count
  end

  def reception_count
    @reception_count ||= Person.where(attending_reception: true).count
  end

  def awaiting_response_count
    @awaiting_response_count ||= person_count - responded_count
  end
end
