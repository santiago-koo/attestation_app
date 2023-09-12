# frozen_string_literal: true

class ApplicationService
  class << self
    def call(...)
      new(...).call
    end
  end

  def return_message(success, payload = {})
    OpenStruct.new(success?: success, payload: payload)
  end
end
