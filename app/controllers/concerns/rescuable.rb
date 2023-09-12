# frozen_string_literal: true

module Rescuable
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

    def resource_not_found
      render json: { message: 'The requested resource was not found.' }, status: :unauthorized
    end
  end
end
