class Api::V1::UsersController < ApplicationController
    def create
        user = User.new(user_params)
        if user.save
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        user = User.find(params[:id])

        posts_count = user.posts.count

        reactions_received_count = Reaction.joins(:post).where(posts: { user_id: user.id }).count

        render json: {
            id: user.id,
            username: user.username,
            stats: {
                posts_count: posts_count,
                reactions_received_count: reactions_received_count
            }
        }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
    end

    private

    def user_params
        params.require(:user).permit(:email, :username)
    end
end
