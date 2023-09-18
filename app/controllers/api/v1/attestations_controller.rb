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

      def attestation_service_result
        @attestation_service_result ||=
          ::AttestationService.call(attestation_params.merge(current_user:))
      end
    end
  end
end
