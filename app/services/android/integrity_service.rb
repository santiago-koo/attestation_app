# frozen_string_literal: true

module Android
  class IntegrityService < ApplicationService
    attr_reader :integrity_token, :challenge, :data

    def initialize(params)
      @integrity_token = params[:token]
      @challenge = params[:challenge]
      @data = params[:data]
    end

    def call
      if valid_nonce?
        return_message(true, play_integrity_service_result)
      else
        return_message(false, { message: 'Nonce is not valid' })
      end
    rescue Google::Apis::ClientError => e
      return_message(false, { message: e.message })
    end

    private

    def valid_nonce?
      local_nonce = Base64.strict_encode64(challenge + Digest::SHA256.hexdigest(Base64.decode64(data)))

      payload.request_details.nonce == local_nonce
    end

    def play_integrity_service_result
      {
        account_details: {
          app_licensing_verdict: payload.account_details.app_licensing_verdict
        },
        app_integrity: {
          app_recognition_verdict: payload.app_integrity.app_recognition_verdict,
          certificate_sha256_digest: payload.app_integrity.certificate_sha256_digest,
          package_name: payload.app_integrity.package_name,
          version_code: payload.app_integrity.version_code
        },
        device_integrity: {
          device_recognition_verdict: payload.device_integrity.device_recognition_verdict
        },
        request_details: {
          nonce: payload.request_details.nonce,
          request_package_name: payload.request_details.request_package_name,
          timestamp_millis: payload.request_details.timestamp_millis
        }
      }
    end

    def payload
      @payload ||= decode_integrity_token&.token_payload_external
    end

    def decode_integrity_token
      decode_integrity_token_request.update!(integrity_token:)
      play_integrity_service.decode_integrity_token(ENV['ANDROID_PACKAGE_NAME'], decode_integrity_token_request)
    end

    def play_integrity_service
      play_integrity_service = Google::Apis::PlayintegrityV1::PlayIntegrityService.new
      play_integrity_service.authorization = google_auth

      play_integrity_service
    end

    def decode_integrity_token_request
      @decode_integrity_token_request ||=
        Google::Apis::PlayintegrityV1::DecodeIntegrityTokenRequest.new
    end

    def google_auth
      ::Google::Auth::ServiceAccountCredentials.make_creds(scope: 'https://www.googleapis.com/auth/playintegrity')
    end
  end
end
