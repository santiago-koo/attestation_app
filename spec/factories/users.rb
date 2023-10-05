# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'example@example.com' }
    password { 'password' }

    trait :with_oauth_access_tokens do
      oauth_access_tokens { build_list :access_token, 1 }
    end
  end
end
