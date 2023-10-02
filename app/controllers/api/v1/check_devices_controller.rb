# frozen_string_literal: true

module Api
  module V1
    class CheckDevicesController < ApplicationController
      def create
        if integrity_service_result.success?
          render_response(
            status_code: :ok,
            message: 'Assertion successfully finished.',
            data: integrity_service_result.payload
          )
        else
          render_response(
            status_code: :forbidden,
            message: integrity_service_result.payload[:message]
          )
        end
      end

      private

      def check_device_params
        params.require(:check_device).permit(:token, :data, :challenge)
      end

      def integrity_service_result
        @integrity_service_result ||= ::Android::IntegrityService.call(check_device_params)
      end
    end
  end
end
