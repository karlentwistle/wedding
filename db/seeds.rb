rsvp_code = RsvpCode.create!(secret: '1234', breakfast: true, reception: true)

person_a = Person.create(full_name: 'Karl Entwistle')
person_b = Person.create(full_name: 'Hannah Sergeant')

rsvp_code.people << [person_a, person_b]

reception_rsvp_code = RsvpCode.create!(secret: '4321', breakfast: false, reception: true)

person_c = Person.create(full_name: 'Tom Coates')
person_d = Person.create(full_name: 'Ruth Aberdeen')

reception_rsvp_code.people << [person_c, person_d]

Food.create(
  [
    {
      title: 'Ham hock terrine with a red onion and micro leaf salad served with sour dough bread',
      sitting: 0
    },
    {
      title: 'Vegetarian terrine with a red onion and micro leaf salad served with sour dough bread (V)',
      sitting: 0
    },
    {
      title: 'Roasted Sea Bass, braised fennel, wild mushroom dauphinoise, Chantilly carrots and saffron cream (GF)',
      sitting: 1
    },
    {
      title: 'Lamb rump with butternut squash puree, fine bean aubergine mash & red current jus (GF)',
      sitting: 1
    },
    {
      title: 'Wild Mushroom, spinach & ricotta strudel served with a butternut squash puree, fine bean aubergine mash & Mushroom cream sauce (V)',
      sitting: 1
    },
    {
      title: 'Sticky toffee pudding with berries and hot toffee sauce (V)',
      sitting: 2
    },
    {
      title: 'Vanilla panna cotta with a seasonal fruit garnish (GF) (V)',
      sitting: 2
    }
  ]
)
