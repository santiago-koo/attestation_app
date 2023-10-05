# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    sequence(:id)
    resource_owner_id { 1 }
    application_id { nil }
    token { SecureRandom.hex(10) }
    refresh_token { SecureRandom.hex(10) }
    expires_in { 600 }
    scopes { 'public' }
    created_at { Time.zone.now }
    revoked_at { nil }
    previous_refresh_token { '' }
  end
end
