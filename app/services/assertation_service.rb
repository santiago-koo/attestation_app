# frozen_string_literal: true

class AssertationService < ApplicationService
  attr_reader :base64_client_data, :base64_assertation, :current_user

  def initialize(params)
    @base64_client_data = params[:clientData]
    @base64_assertation = params[:assertation]
    @current_user = params[:current_user]
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
    client_data_json['challenge'] == assert_user_challenge.token
  end

  # Step umber 5
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def counter_greater_than_zero?
    authenticator_data.sign_count.positive?
  end

  # Step number 4
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def app_id_equals_rp_id_hash?
    authenticator_data.rp_id_hash == ::Digest::SHA256.digest("#{ENV['IOS_TEAM_ID']}.#{ENV['IOS_BUNDLE_ID']}")
  end

  # Step number 3
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def signature_valid?
    user_attestation.eliptic_curve_public_key.verify(
      OpenSSL::Digest.new('SHA256'),
      signature,
      nonce
    )
  end

  # Step number 2
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def nonce
    ::Digest::SHA256.digest(authenticator_data.data + client_data_hash)
  end

  # Step number 1
  # https://developer.apple.com/documentation/devicecheck/validating_apps_that_connect_to_your_server#3579385
  def client_data_hash
    ::Digest::SHA256.digest(client_data_json.to_json)
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

  def client_data_json
    @client_data_json ||= JSON.parse(Base64.decode64(base64_client_data))
  end

  def user_attestation
    @user_attestation ||= current_user.user_attestation
  end

  def assert_user_challenge
    @assert_user_challenge ||= current_user.user_challenges.active.last
  end
end
