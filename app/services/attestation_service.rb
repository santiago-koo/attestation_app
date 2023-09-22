# frozen_string_literal: true

class AttestationService < ApplicationService
  attr_reader :base64_attestation, :base64_key_id, :user_challenge

  def initialize(params)
    @base64_attestation = params[:attestation]
    @base64_key_id = params[:keyID]
    @user_challenge = params[:user_challenge]
    set_user_challenge_type
  end

  def call
    return return_message(true, { user_attestation: user_challenge.user_attestation }) if user_already_attested?

    if successful_attestation?
      user.update(is_attested: true)
      user_challenge.update(is_active: false)

      return_message(true, { user_attestation: create_user_attestation })
    else
      return_message(false, { msessage: 'Attestation process has failed' })
    end
  end

  private

  def user_already_attested?
    user.is_attested?
  end

  def successful_attestation?
    steps_1_3_4_8_valid? &&
      cred_cert_public_key_equals_key_id? &&
      app_id_equals_rp_id_hash? &&
      authenticator_data_sign_counter_equals_zero? &&
      attested_credential_data_id_equals_key_id?
  end

  # "Store the Public Key and Receipt" step
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def create_user_attestation
    UserAttestation.create(
      receipt: Base64.encode64(attestation_object.attestation_statement.send(:statement)['receipt']),
      public_key: Base64.encode64(attestation_object.attestation_statement.attestation_certificate.public_key.to_der),
      user_challenge_id: user_challenge.id
    )
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

  # Step number  5
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def cred_cert_public_key_equals_key_id?
    public_key = attestation_object.attestation_statement.attestation_certificate.public_key
    public_key_asn1_sequence = OpenSSL::ASN1.decode(public_key.to_der)
    sequence_value = public_key_asn1_sequence.find { |pkas| pkas.value.is_a? String }

    return false if sequence_value.nil?

    Digest::SHA256.digest(sequence_value.value) == Base64.decode64(base64_key_id)
  end

  # Step number 2
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def client_data_hash
    ::Digest::SHA256.digest(user_challenge.token)
  end

  # Step number 1, 3, 4 and 8
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3576643
  def steps_1_3_4_8_valid?
    attestation_object.valid_attestation_statement?(client_data_hash)
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

  def user
    @user ||= user_challenge.user
  end

  def set_user_challenge_type
    user_challenge.attestation!
  end
end
