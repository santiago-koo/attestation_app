# frozen_string_literal: true

class SigninService < ApplicationService
  class InvalidCredentialsError < StandardError; end

  attr_reader :email, :password

  def initialize(params)
    @email = params[:email].downcase
    @password = params[:password]
  end

  def call
    raise InvalidCredentialsError if user.blank?

    user.authenticate(password)
    remove_reset_password_token
    user.save

    payload = {
      user:,
      tokens: user.generate_tokens!
    }
    return_message(true, payload)
  end

  private

  def remove_reset_password_token
    user.reset_password_token = nil
  end

  def user
    @user ||= User.find_by!(email:)
  end
end
