# frozen_string_literal: true

module Api
  module V1
    class UserChallengesController < ApplicationController
      before_action :doorkeeper_authorize!
      respond_to :json

      def index
        render_response(
          status_code: :ok,
          data: { user_challenges: }
        )
      end

      def create
        service_result = ::CreateUserChallenge.call(user_challenge_params.merge(user: current_user))

        unless service_result.success?
          render_response(status_code: :internal_server_error, message: service_result.payload[:mesage])
        end

        render_response(status_code: :created, data: { user_challenge: service_result.payload })
      end

      def show
        render_response(
          status_code: :ok,
          data: { user_challenge: }
        )
      end

      private

      def user_challenges
        UserChallenge.where(params[:user_id])
      end

      def user_challenge
        UserChallenge.find_by!(id: params[:id], user_id: current_user.id)
      end

      def user_challenge_params
        params.require(:user_challenge).permit(:device_id)
      end
    end
  end
end
