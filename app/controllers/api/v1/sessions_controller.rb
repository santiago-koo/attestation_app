# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      before_action :doorkeeper_authorize!, only: %i[signout]
      respond_to :json

      def signin
        if signin_service_result.success?
          render_response(
            status_code: :ok,
            message: 'Signed in successfully.',
            data: signin_response_data
          )
        else
          render_response(status_code: :forbidden, message: 'Could not sign in')
        end
      end

      def signout
        if signout_service_result.success?
          render_response(status_code: :no_content)
        else
          render_response(status_code: :forbidden, message: 'Could not sign out')
        end
      end

      private

      def signin_response_data
        {
          user: signin_service_result.payload[:user],
          tokens: signin_service_result.payload[:tokens].presence || 'Could not sign in'
        }
      end

      def signin_service_result
        @signin_service_result ||= ::SigninService.call(signin_params)
      end

      def signout_service_result
        ::SignoutService.call(current_user:)
      end

      def signin_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
