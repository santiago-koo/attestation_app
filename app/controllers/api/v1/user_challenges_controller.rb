# frozen_string_literal: true

module Api
  module V1
    class UserChallengesController < ApplicationController
      respond_to :json

      def create
        if service_result.success?
          render_response(status_code: :created, data: { user_challenge: service_result.payload })
        else
          render_response(status_code: :internal_server_error, message: service_result.payload[:mesage])
        end
      end

      private

      def service_result
        case request.headers['HTTP_DEVICE_OS']
        when 'iOS'
          ::Apple::UserChallengeService.call(apple_params)
        when 'Android'
          ::Android::ChallengeService.call
        end
      end

      def apple_params
        {
          device_id: request.headers['HTTP_DEVICE_ID'],
          current_user:
        }
      end
    end
  end
end
