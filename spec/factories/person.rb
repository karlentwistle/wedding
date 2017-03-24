FactoryGirl.define do
  factory :person do
    full_name { Faker::Name.name }
  end
end
