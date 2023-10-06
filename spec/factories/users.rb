# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }

    trait :with_oauth_access_tokens do
      oauth_access_tokens { build_list :access_token, 1 }
    end

    trait :with_user_challenges do
      user_challenges { build_list :user_challenge, 1 }
    end
  end
end
