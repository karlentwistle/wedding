rsvp_code = RsvpCode.create!(secret: '1234')

person_a = Person.create(full_name: 'Karl Entwistle')
person_b = Person.create(full_name: 'Hannah Sergeant')

rsvp_code.people << [person_a, person_b]

Food.create(
  [
    {
      title: 'Ham hock terrine with a red onion and micro leaf salad served with sour dough bread',
      sitting: 0
    },
    {
      title: 'Vegetarian terrine with a red onion and micro leaf salad served with sour dough bread',
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
      title: 'Vegetarian option',
      sitting: 1
    },
    {
      title: 'Sticky toffee pudding with berries and hot toffee sauce',
      sitting: 2
    },
    {
      title: 'Vanilla panna cotta with a seasonal fruit garnish (GF)',
      sitting: 2
    }
  ]
)
