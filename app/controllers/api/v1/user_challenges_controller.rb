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
        UserChallenge.find!(id: params[:id], user_id: params[:user_id])
      end
    end
  end
end
