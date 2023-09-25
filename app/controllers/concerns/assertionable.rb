# frozen_string_literal: true

module Assertionable
  extend ActiveSupport::Concern

  included do
    def assertation_service_result
      @assertation_service_result ||= assertion_class[request.headers['HTTP_DEVICE_OS']]
    end

    def assertion_params
      params.require(:payment).permit(:keyID, :assertation, :clientData)
    end

    def assertion_class
      {
        'iOS' => ::Apple::AssertationService.call(assertion_params.merge(current_user:))
      }
    end
  end
end
