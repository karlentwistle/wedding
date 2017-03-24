RsvpCode.create!(secret: 'ceremony', ceremony: true, reception: false).people << (
  Person.create!(
    [
      { full_name: 'Thalia Gerrish' },
      { full_name: 'Laquanda Weisz' },
      { full_name: 'Delisa Flinn' },
    ]
  )
)

RsvpCode.create!(secret: 'reception', ceremony: false, reception: true).people << (
  Person.create!(
    [
      { full_name: 'Emmanuel Blouin' },
      { full_name: 'Khalilah Bierce' },
      { full_name: 'Towanda Spector' },
      { full_name: 'Delorse Ocheltree' },
      { full_name: 'Nannie Lavallee' },
    ]
  )
)

RsvpCode.create!(secret: 'everything', ceremony: true, reception: true).people << (
  Person.create!(
    [
      { full_name: 'Randi Stavros' },
      { full_name: 'Tanesha Cruzado' },
      { full_name: 'Truman Hemminger' },
      { full_name: 'Yong Kobel', child: true },
      { full_name: 'Everett Cousino', child: true },
      { full_name: 'Sondra Dasilva', child: true },
    ]
  )
)

Food.create!(
  [
    {
      title: 'Crispy squid with capers',
      sitting: 0,
    },
    {
      title: 'Lime & pepper chicken wraps',
      sitting: 0,
    },
    {
      title: 'Roasted Corn and Pepper Salsa',
      sitting: 0,
    },
    {
      title: 'Fried Ravioli',
      sitting: 0,
      child: true,
    },
    {
      title: 'Rib-Eye, T-Bone, and Strip Steaks Cut Over',
      sitting: 1,
    },
    {
      title: 'Chilled Beet Soup',
      sitting: 1,
    },
    {
      title: 'Raymond Blanc\'s cassoulet',
      sitting: 1,
    },
    {
      title: 'Kid Friendly Salmon',
      sitting: 1,
      child: true,
    },
    {
      title: 'Drunken Cherries with Orange Blossom Chenna',
      sitting: 2,
    },
    {
      title: 'Flan',
      sitting: 2,
    },
    {
      title: 'Nutella pizza',
      sitting: 2,
      child: true,
    },
  ]
)
