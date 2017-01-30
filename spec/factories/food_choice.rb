FactoryGirl.define do
  factory :food_choice do
    association :person
    association :food
  end
end
