# frozen_string_literal: true

class SignupService < ApplicationService
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def call
    user = User.new(email:, password:)
    user.email = email.strip.downcase
    user.password = password.strip

    user.save!

    session = ::SigninService.call({ email:, password: })
    user = session.payload[:user]
    tokens = session.payload[:tokens]

    return_message(true, { user:, tokens: })
  end
end
