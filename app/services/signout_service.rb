# frozen_string_literal: true

class SignoutService < ApplicationService
  attr_reader :current_user

  def initialize(params)
    @current_user = params[:current_user]
  end

  def call
    current_user.revoke_tokens!
    current_user.update(is_attested: false)

    return_message(true)
  end
end
