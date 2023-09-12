# frozen_string_literal: true

module Api
  module V1
    class UserChallengesController < ApplicationController
      before_action :doorkeeper_authorize!
      respond_to :json

      def index
        render json: {
          data: { user_challenges: }
        }, status: :ok
      end

      def show
        render json: {
          data: { user_challenge: }
        }, status: :ok
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