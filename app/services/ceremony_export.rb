require 'csv'

class CeremonyExport
  ATTRIBUTES = %w{
    full_name
    dietary_requirements
    starter_choice
    main_choice
    dessert_choice
    child
  }.freeze

  def perform
    CSV.generate(headers: true) do |csv|
      csv << ATTRIBUTES

      Person.attending_ceremony.all.each do |user|
        csv << ATTRIBUTES.map{ |attr| user.send(attr) }
      end
    end
  end
end

