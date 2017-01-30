FactoryGirl.define do
  factory :food do
    title { Faker::Food.ingredient }
    sitting { Food.sittings.keys.sample }
  end
end
