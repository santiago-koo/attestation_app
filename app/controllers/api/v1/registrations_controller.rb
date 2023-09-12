# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      respond_to :json

      def signup
        render_response(status_code: :forbidden, message: 'Could not sign up') unless signup_service_result.success?

        render_response(
          status_code: :ok,
          message: 'Signed up successfully.',
          data: signup_response_data
        )
      end

      private

      def signup_response_data
        tokens = signup_service_result.payload[:tokens].presence || 'Could not sign un'
        user = signup_service_result.payload[:user]

        { user:, tokens: }
      end

      def signup_service_result
        @signup_service_result ||= ::SignupService.call(signup_params)
      end

      def signup_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
