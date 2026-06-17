class ApplicationController < ActionController::API
    before_action :authenticate_user!

    attr_reader :current_user

    private

    def authenticate_user!
        auth_header = request.headers["Authorization"]

        token = auth_header&.split(" ")&.last

        if token.nil?
            return render json: { error: "Missing authorization token" }, status: :unauthorized
        end

        decoded = AuthTokenService.decode_access_token(token)

        case decoded
        when :expired
            render json: { error: "Token expired", code: "TOKEN_EXPIRED" }, status: :unauthorized
        when nil
            render json: { error: "Invalid token structure" }, status: :unauthorized
        else
            @current_user = User.find_by(id: decoded[:user_id])
            render json: { error: "User account no longer exists" }, status: :unauthorized if @current_user.nil?
        end
    end
end
