FactoryGirl.define do
  factory :person do
    full_name { Faker::Name.name }
    association :rsvp_code
  end
end
