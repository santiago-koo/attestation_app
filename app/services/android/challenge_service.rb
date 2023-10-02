# frozen_string_literal: true

module Android
  class ChallengeService < ApplicationService
    def call
      return_message(true, token)
    end

    private

    def token
      {
        token: Digest::SHA256.hexdigest(SecureRandom.random_bytes(512))
      }
    end
  end
end
