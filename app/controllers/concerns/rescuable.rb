# frozen_string_literal: true

module Rescuable
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
    rescue_from ActionController::ParameterMissing, with: :missing_params

    def resource_not_found(_exception)
      render json: { message: 'The requested resource was not found.' }, status: :unauthorized
    end

    def missing_params(exception)
      render json: { message: exception.message }, status: :bad_request
    end
  end
end
