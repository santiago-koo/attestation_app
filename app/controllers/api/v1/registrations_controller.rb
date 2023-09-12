# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      respond_to :json

      def create
        result = session_service.signup(signup_params)

        render json: {
          status: { code: :ok, message: 'Signed up successfully.' },
          data: { user: result.payload }
        }
      end

      private

      def signup_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
