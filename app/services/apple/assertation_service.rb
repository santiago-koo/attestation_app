# frozen_string_literal: true

module Apple
  class AssertationService < ApplicationService
    attr_reader :assertion_object, :current_user

    def initialize(params)
      @current_user = params[:current_user]
      @assertion_object = AssertionObject.new(params[:clientData], params[:assertation])
      set_user_challenge_type
    end

    def call
      if successful_assertion?
        assert_user_challenge.update(is_active: false)
        return_message(true)
      else
        return_message(false, { msessage: 'Assertion process has failed' })
      end
    end

    private

    def successful_assertion?
      signature_valid? &&
        app_id_equals_rp_id_hash? &&
        counter_greater_than_zero? &&
        received_challenge_equals_stored_challenge?
    end

    # Step umber 6
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def received_challenge_equals_stored_challenge?
      assertion_object.client_data_json['challenge'] == assert_user_challenge.token
    end

    # Step umber 5
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def counter_greater_than_zero?
      assertion_object.authenticator_data.sign_count.positive?
    end

    # Step number 4
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def app_id_equals_rp_id_hash?
      assertion_object.authenticator_data.rp_id_hash ==
        ::Digest::SHA256.digest("#{ENV['IOS_TEAM_ID']}.#{ENV['IOS_BUNDLE_ID']}")
    end

    # Step number 3
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def signature_valid?
      user_attestation.eliptic_curve_public_key.verify(
        OpenSSL::Digest.new('SHA256'),
        assertion_object.signature,
        nonce
      )
    end

    # Step number 2
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def nonce
      ::Digest::SHA256.digest(assertion_object.authenticator_data.data + client_data_hash)
    end

    # Step number 1
    # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
    def client_data_hash
      ::Digest::SHA256.digest(assertion_object.raw_client_data)
    end

    def user_attestation
      @user_attestation ||= current_user.user_challenges.attestation.where(is_active: false).last.user_attestation
    end

    def assert_user_challenge
      @assert_user_challenge ||= current_user.user_challenges.active.last
    end

    def set_user_challenge_type
      assert_user_challenge.assertion!
    end
  end
end
