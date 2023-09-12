# frozen_string_literal: true

class SignupService < ApplicationService
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def call
    user = User.new params
    user.email = email.strip_downcase
    user.password = password.strip

    user.save!

    return_message(true, user)
  end
end
