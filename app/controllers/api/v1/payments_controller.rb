# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :doorkeeper_authorize!

      def create
        if assertation_service_result.success?
          render_response(
            status_code: :ok,
            message: 'Assertion successfully finished.'
          )
        else
          render_response(
            status_code: :forbidden,
            message: assertation_service_result.payload[:message]
          )
        end
      end

      private

      def assertation_service_result
        @assertation_service_result ||= ::AssertationService.call(payment_params.merge(current_user:))
      end

      def payment_params
        params.permit(:keyID, :assertation, :clientData)
      end
    end
  end
end
