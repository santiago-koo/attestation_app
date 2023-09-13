# frozen_string_literal: true

class CreateUserChallenge < ApplicationService
  attr_reader :device_id, :current_user

  def initialize(params)
    @device_id = params[:device_id]
    @current_user = params[:user]
  end

  def call
    return_message(false, { msessage: 'Resource not created' }) unless new_user_challenge.valid?

    new_user_challenge.save
    return_message(true, new_user_challenge)
  end

  private

  def new_user_challenge
    @new_user_challenge ||= UserChallenge.new(new_user_challenge_params)
  end

  def new_user_challenge_params
    {
      token: Digest::SHA256.hexdigest(SecureRandom.random_bytes(512)),
      user_id: current_user.id,
      device_id:
    }
  end
end
