# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


rsvp_code = RsvpCode.create!(secret: '1234')

person_a = Person.create(full_name: 'Karl Entwistle')
person_b = Person.create(full_name: 'Hannah Sergeant')

rsvp_code.people << [person_a, person_b]
