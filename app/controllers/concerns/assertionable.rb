# frozen_string_literal: true

module Assertionable
  extend ActiveSupport::Concern

  included do
    def assertation_service_result
      @assertation_service_result ||= ::Apple::AssertationService.call(assertion_params.merge(current_user:))
    end

    def assertion_validate!
      raise StandardError, 'Assertion has failed' unless assertation_service_result.success?
    end

    def assertion_params
      params.require(:payment).permit(:keyID, :assertation, :clientData)
    end
  end
end
