# frozen_string_literal: true

class CreateUserChallenge < ApplicationService
  attr_reader :user_challenge_params

  def initialize(user_challenge_params)
    @user_challenge_params = user_challenge_params
  end

  def call
    user_challenge = UserChallenge.create(user_challenge_params)

    return_message(true, user_challenge)
  end
end
