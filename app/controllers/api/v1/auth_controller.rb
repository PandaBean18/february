class Api::V1::AuthController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :signup, :login, :google, :refresh ]

    def signup
        user = User.new(signup_params)

        if user.save
            render json: AuthTokenService.issue_session(user), status: :ok
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
            render json: AuthTokenService.issue_session(user), status: :ok
        else
            render json: { errors: "Invalid email or password" }, status: :unauthorized
        end
    end

    def google
        google_payload = GoogleAuthService.verify(params[:id_token])

        if google_payload.nil?
            return render json: { error: "Invalid or expired Google Token" }, status: :unauthorized
        end

        email = google_payload[:email]

        user = User.find_by(email: email)

        if user.nil?
            user = User.new(email: email, username: google_payload[:name].to_s.downcase.delete(" ") + SecureRandom.hex(2), password: SecureRandom.hex(16))

            unless user.save
                return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
        end
        render json: AuthTokenService.issue_session(user), status: :ok
    end

    def refresh
        stored_token = RefreshToken.find_by(token: params[:refresh_token])

        if stored_token.nil? || stored_token.expires_at < Time.now
            return ender json: { error: "Invalid or expired refresh token. Please re-authenticate." }, status: :unauthorized
        end

        user = stored_token.user

        ActiveRecord::Base.transaction do
            stored_token.destroy!

            render json: AuthTokenService.issue_session(user), status: :ok
        end
    end

    def logout
        stored_token = RefreshToken.find_by(token: params[:refresh_token])
        stored_token&.destroy!
        render json: { message: "Logged out successfully" }, status: :ok
    end

    private

    def signup_params
        params.require(:user).permit(:email, :username, :password)
    end
end
