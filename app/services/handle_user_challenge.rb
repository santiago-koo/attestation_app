# frozen_string_literal: true

class HandleUserChallenge < ApplicationService
  attr_reader :device_id, :current_user

  def initialize(params)
    @device_id = params[:device_id]
    @current_user = params[:user]
  end

  def call
    return return_message(true, last_active_user_challenge) if last_active_user_challenge_available?

    deactivate_last_active_user_challenge
    create_new_user_challenge
  end

  private

  def last_active_user_challenge_available?
    last_active_user_challenge.present? &&
      Time.zone.now < last_active_user_challenge.expires_at
  end

  def last_active_user_challenge
    @last_active_user_challenge ||=
      UserChallenge
      .active
      .where(
        user_id: current_user.id,
        device_id:
      ).last
  end

  def create_new_user_challenge
    return return_message(true, new_user_challenge) if new_user_challenge.save

    return_message(false, { msessage: 'Resource not created' })
  end

  def deactivate_last_active_user_challenge
    last_active_user_challenge.update(is_active: false) if last_active_user_challenge.present?
  end

  def new_user_challenge
    @new_user_challenge ||= UserChallenge.new(new_user_challenge_params)
  end

  def new_user_challenge_params
    {
      expires_at: Time.zone.now + current_user.oauth_access_tokens.last.expires_in,
      is_active: true,
      token: Digest::SHA256.hexdigest(SecureRandom.random_bytes(512)),
      user_id: current_user.id,
      device_id:
    }
  end
end
