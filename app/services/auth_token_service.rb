class AuthTokenService
    JWT_SECRET = Rails.application.credentials.secret_key_base

    def self.generate_access_token(user)
        payload = {
            user_id: user.id,
            exp: 45.minutes.from_now.to_i,
            iat: Time.now.to_i
        }
        JWT.encode(payload, JWT_SECRET, "HS256")
    end

    def self.decode_access_token(token)
        body = JWT.decode(token, JWT_SECRET, true, { algorithm: "HS256" })[0]
        HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
        :expired
    rescue JWT::DecodeError
        nil
    end

    def self.issue_session(user)
        access_token = generate_access_token(user)
        secure_refresh_token = SecureRandom.hex(40)

        user.refresh_tokens.create!(
            token: secure_refresh_token,
            expires_at: 30.days.from_now
        )

        {
            access_token: access_token,
            refresh_token: secure_refresh_token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email
            }
        }
    end
end
