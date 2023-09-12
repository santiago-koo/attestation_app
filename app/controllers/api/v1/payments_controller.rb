# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :doorkeeper_authorize!

      def create
        render json: { data: 'ok' }, status: :ok
      end
    end
  end
end
