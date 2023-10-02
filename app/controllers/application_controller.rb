# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Rescuable
  include Assertionable

  skip_before_action :verify_authenticity_token

  protected

  def render_response(status_code:, message: '', data: {})
    render json: {
      status: { code: status_code, message: },
      data:
    }, status: status_code
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
