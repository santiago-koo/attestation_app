# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < ApplicationController
      include Assertionable

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
    end
  end
end
