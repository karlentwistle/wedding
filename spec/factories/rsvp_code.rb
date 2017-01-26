FactoryGirl.define do
  factory :rsvp_code do
    secret { Faker::Code.imei }
  end
end
