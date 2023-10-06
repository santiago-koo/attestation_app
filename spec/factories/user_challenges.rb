# frozen_string_literal: true

FactoryBot.define do
  factory :user_challenge do
    sequence(:id)
    user_id { 1 }
    token { SecureRandom.hex(10) }
    device_id { '473CAA64-7F04-40D4-80E1-AB78765654C6' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    is_active { true }
    expires_at { Time.zone.now + 10.minutes }
    type_status { 'empty' }
  end
end
