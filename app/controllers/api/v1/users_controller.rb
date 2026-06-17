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
        user = User.includes(:profile_picture).find(params[:id])

        posts_count = user.posts.count

        reactions_received_count = Reaction.joins(:post).where(posts: { user_id: user.id }).count

        available_stickers = Sticker.includes(:medium).all

        render json: {
            id: user.id,
            username: user.username,
            profile_picture_url: user.profile_picture&.cloudinary_url,
            stats: {
                posts_count: posts_count,
                reactions_received_count: reactions_received_count
            },
            available_stickers: available_stickers.map { |sticker|
                {
                    id: sticker.id,
                    name: sticker.name,
                    url: sticker.cloudinary_url
                }
            }
        }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
    end

    def update
        user = User.find(params[:id])

        ActiveRecord::Base.transaction do
            if params[:user][:cloudinary_public_id].present?
                new_avatar = Medium.create!(
                    media_type: :profile_picture,
                    cloudinary_public_id: params[:user][:cloudinary_public_id]
                )

                user.profile_picture = new_avatar
            end

            if user.update(user_params.except(:cloudinary_public_id))
                posts_count = user.posts.count
                reactions_received_count = Reaction.joins(:post).where(posts: { user_id: user.id }).count
                available_stickers = Sticker.includes(:medium).all

                render json: {
                    id: user.id,
                    username: user.username,
                    profile_picture_url: user.profile_picture&.cloudinary_url,
                    stats: {
                        posts_count: posts_count,
                        reactions_received_count: reactions_received_count
                    },
                    available_stickers: available_stickers.map { |sticker|
                        {
                            id: sticker.id,
                            name: sticker.name,
                            url: sticker.cloudinary_url
                        }
                    }
                }, status: :ok
            else
                render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :username, :cloudinary_public_id)
    end
end
