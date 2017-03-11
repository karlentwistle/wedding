FactoryGirl.define do
  factory :rsvp_code do
    secret { Faker::Code.imei }
    reception { true }
    ceremony { [true, false].sample }
  end
end
