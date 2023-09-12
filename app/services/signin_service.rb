# frozen_string_literal: true

class SigninService < ApplicationService
  class InvalidCredentialsError < StandardError; end

  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def call
    user = User.find_by!(email:).authenticate(password)

    raise_invalid_credentials if user.blank?

    tokens = user.generate_tokens!
    user = remove_reset_password_token(user)

    user.save
    payload = {
      user:,
      tokens:
    }
    return_message(true, payload)
  end

  private

  def remove_reset_password_token(user)
    user.reset_password_token = nil
    user
  end

  def raise_invalid_credentials
    raise InvalidCredentialsError
  end
end
