# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      before_action :doorkeeper_authorize!, only: %i[destroy]
      respond_to :json

      def create
        result = ::SigninService.call(signin_params)

        if result.success?
          render json: {
            status: { code: :ok, message: 'Signed in successfully.' },
            meta: result.payload[:tokens].presence || 'Could not sign in',
            data: { user: result.payload[:user] }
          }
        else
          render json: {
            status: { code: :forbidden },
            meta: 'Could not sign in',
            data: {}
          }
        end
      end

      def destroy
        # TODO
        render json: {
          status: { code: :no_content, message: 'Signed out successfully' }
        }
      end

      private

      def signin_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
