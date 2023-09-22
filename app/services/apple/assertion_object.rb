# frozen_string_literal: true

module Apple
  class AssertionObject
    attr_reader :base64_client_data, :base64_assertation

    def initialize(base64_client_data, base64_assertation)
      @base64_client_data = base64_client_data
      @base64_assertation = base64_assertation
    end

    def signature
      @signature ||= assertation['signature']
    end

    def authenticator_data
      @authenticator_data ||= WebAuthn::AuthenticatorData.deserialize(assertation['authenticatorData'])
    end

    def assertation
      @assertation ||= CBOR.decode(Base64.decode64(base64_assertation))
    end

    def raw_client_data
      @raw_client_data ||= Base64.decode64(base64_client_data)
    end

    def client_data_json
      @client_data_json ||= JSON.parse(Base64.decode64(base64_client_data))
    end
  end
end
