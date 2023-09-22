# frozen_string_literal: true

module Api
  module V1
    class AttestationsController < ApplicationController
      before_action :doorkeeper_authorize!

      def create
        if attestation_service_result.success?
          render_response(
            status_code: :ok,
            message: 'Attestation successfully finished.',
            data: attestation_service_result.payload
          )
        else
          render_response(
            status_code: :forbidden,
            message: attestation_service_result.payload[:message]
          )
        end
      end

      private

      def attestation_params
        params.permit(:keyID, :attestation)
      end

      def user_challenge_params
        params.permit(:device_id)
      end

      def user_challenge
        @user_challenge ||=
          UserChallenge
          .active
          .where(user_id: current_user.id)
          .last
      end

      def attestation_service_result
        @attestation_service_result ||=
          ::Apple::AttestationService.call(attestation_params.merge(user_challenge:))
      end
    end
  end
end
