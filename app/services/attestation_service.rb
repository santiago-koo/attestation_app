# frozen_string_literal: true

class AttestationService < ApplicationService
  attr_reader :base64_attestation, :base64_key_id

  def initialize(params)
    @base64_attestation = params[:attestation]
    @base64_key_id = params[:keyID]
    @current_user = params[:current_user]
  end

  def call
    if successful_attestation?
      return_message(true, { user_attestation: create_user_attestation })
    else
      return_message(false, { msessage: 'Attestation process has failed' })
    end
  end

  private

  def successful_attestation?
    attestation_object.valid_attestation_statement?(client_data_hash) &&
      attestation_object.valid_attested_credential? &&
      app_id_equals_rp_id_hash? &&
      authenticator_data_sign_counter_equals_zero? &&
      attested_credential_data_id_equals_key_id?
  end

  def create_user_attestation
    # TODO
  end

  # Step number 9
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def attested_credential_data_id_equals_key_id?
    ::Base64.decode64(base64_key_id) == attestation_object.authenticator_data.attested_credential_data.id
  end

  # Step number 7
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def authenticator_data_sign_counter_equals_zero?
    attestation_object.authenticator_data.sign_count.zero?
  end

  # Step number  6
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def app_id_equals_rp_id_hash?
    attestation_object.authenticator_data.rp_id_hash == ::Digest::SHA256.digest("#{ENV['IOS_TEAM_ID']}.#{ENV['IOS_BUNDLE_ID']}")
  end

  # Step number 2
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def client_data_hash
    # TODO: Query UserChallenge
    ::Digest::SHA256.digest('41b72ded90bb49219a5ba949349ed3a49618d728d58aa9508563930318c8e858')
  end

  def attestation_object
    @attestation_object ||= WebAuthn::AttestationObject.deserialize(cbor_data_encoded, relying_party)
  end

  def cbor_data_encoded
    raw_data = ::Base64.decode64(base64_attestation)

    cbor_data_decoded = ::CBOR.decode(raw_data)
    cbor_data_decoded['fmt'] = 'apple'
    ::CBOR.encode(cbor_data_decoded)
  end

  def relying_party
    WebAuthn::RelyingParty.new(encoding: 'base64', origin: 'localhost:3000', name: 'WebAuthn Rails Demo App')
  end
end
