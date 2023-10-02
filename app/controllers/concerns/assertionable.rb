# frozen_string_literal: true

module Assertionable
  extend ActiveSupport::Concern

  included do
    def assertation_service_result
      @assertation_service_result ||= assertion_class
    end

    def assertion_validate!
      raise StandardError, 'Assertion has failed' unless assertation_service_result.success?
    end

    def check_device_params
      params.require(:check_device).permit(:token, :data, :challenge)
    end

    def assertion_params
      params.require(:payment).permit(:keyID, :assertation, :clientData)
    end

    def assertion_class
      case request.headers['HTTP_DEVICE_OS']
      when 'iOS'
        ::Apple::AssertationService.call(assertion_params.merge(current_user:))
      when 'Android'
        ::Android::IntegrityService.call(check_device_params)
      end
    end
  end
end
