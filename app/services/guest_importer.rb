require 'csv'

class GuestImporter

  def initialize(csv_path)
    @csv_path = csv_path
  end

  def perform
    ActiveRecord::Base.transaction do
      CSV.foreach(csv_path, headers: true) do |row|
        Row.new(row).perform
      end
    end
  end

  private

  attr_reader :csv_path

  class Row
    def initialize(row)
      @row = row
    end

    def perform
      create_rsvp!
      create_people!
    end

    private

    attr_reader :row, :rsvp

    def people
      [
        row['Person 1'],
        row['Person 2'],
        row['Person 3'],
        row['Person 4'],
        row['Person 5'],
        row['Person 6'],
        row['Person 7'],
        row['Person 8'],
      ].compact
    end

    def create_people!
      rsvp.people.create!(
        people.map do |person|
          {full_name: person}
        end
      )
    end

    def create_rsvp!
      @rsvp = RsvpCode.create!(
        secret: code, ceremony: ceremony?, reception: reception?
      )
    end

    def code
      row['Code']
    end

    def ceremony?
      row['Ceremony'] == 'Y'
    end

    def reception?
      row['Reception'] == 'Y'
    end
  end

end

