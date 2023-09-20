# frozen_string_literal: true

module Api
  module V1
    class AttestationsController < ApplicationController
      def create
        if attestation_service_result.success?
          render_response(
            status_code: :ok,
            message: 'Attestation successfully finished.',
            data: attestation_service_result.payload
          )
        else
          render_response(status_code: :forbidden, message: 'Could not sign up')
        end
      end

      private

      def attestation_params
        params.permit(:keyID, :attestation)
      end

      def user_challenge_params
        params.permit(:device_id, :challenge)
      end

      def user_challenge
        @user_challenge ||=
          UserChallenge.where(user_id: current_user.id, device_id: user_challenge_params[:device_id]).last
      end

      def attestation_service_result
        @attestation_service_result ||=
          ::AttestationService.call(attestation_params.merge(user_challenge:))
      end
    end
  end
end
