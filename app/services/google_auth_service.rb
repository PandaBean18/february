require "googleauth/id_tokens"

class GoogleAuthService
    def self.verify(id_token)
        payload = Google::Auth::IDTokens.verify_oidc(id_token, aud: ENV["GOOGLE_CLIENT_ID"])
        HashWithIndifferentAccess.new(payload)
    rescue StandardError => e
        Rails.logger.error "Google Verification Failure: #{e.message}"
        nil
    end
end
