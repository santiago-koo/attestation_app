# frozen_string_literal: true

module Android
  module VeredictPolicy
    private

    def veredict_valid?
      request_details_valid? &&
        app_integrity_valid? &&
        device_integrity_valid?
    end

    def request_details_valid?
      nonce_valid? && package_name_valid?
    end

    def app_integrity_valid?
      payload.app_integrity.app_recognition_verdict == 'PLAY_RECOGNIZED'
    end

    def device_integrity_valid?
      'MEETS_DEVICE_INTEGRITY'.in? payload.device_integrity.device_recognition_verdict
    end

    def account_details_valid?
      payload.account_details.app_licensing_verdict == 'LICENSED'
    end

    def nonce_valid?
      data_hash = Digest::SHA256.hexdigest(Base64.decode64(data))
      local_nonce = Base64.strict_encode64(challenge + data_hash)

      payload.request_details.nonce == local_nonce
    end

    def package_name_valid?
      payload.request_details.request_package_name == ENV['ANDROID_PACKAGE_NAME']
    end
  end
end
