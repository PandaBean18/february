class Api::V1::PostsController < ApplicationController
    before_action :set_post, only: [ :update, :destroy ]

    def index
        posts = Post.includes(:user).order(created_at: :desc).limit(50)

        render json: posts.map { |post|
            serialize_post(post)
        }, status: :ok
    end

    def create
        ActiveRecord::Base.transaction do
            @post = Post.new(post_params)

            if @post.save
                sticker_tokens = @post.story.scan(/:([a-zA-Z0-9_-]+):/).flatten

                if sticker_tokens.any?
                    matched_stickers = Sticker.where(name: sticker_tokens)

                    @post.stickers << matched_stickers
                end

                render json: serialize_post(@post), status: :created
            else
                render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    def update
        if @post.update(post_params)
            render json: @post, status: :ok
        else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        head :no_content
    end

    private

    def set_post
        @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
    end

    def post_params
        params.require(:post).permit(:user_id, :category, :kind, :story)
    end

    def serialize_post(post)
        {
            id: post.id,
            category: post.category,
            story: post.story,
            created_at: post.created_at,
            user: {
                id: post.user.id,
                username: post.user.username,
                profile_picture_url: post.user.profile_picture&.cloudinary_url
            },
            stickers: post.stickers.map { |sticker|
                {
                    id: sticker.id,
                    name: sticker.name,
                    url: sticker.cloudinary_url
                }
            },
            reaction_counts: post.reaction.group(:reaction_type).count
        }
    end
end
