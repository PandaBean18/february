class Api::V1::PostsController < ApplicationController
    before_action :set_post, only: [ :update, :destroy ]

    def index
        posts = Post.includes(:user).order(created_at: :desc).limit(50)
        reaction_counts = Reaction.where(post_id: posts.map(&:id)).group(:post_id, :reaction_type).count

        render json: posts.map { |post|
            post_reactions = reaction_counts.select { |key, _| key[0] == post.id }
                                                    .transform_keys { |key| key[1] }

            {
                id: post.id,
                category: post.category,
                story: post.story,
                created_at: post.created_at,
                user: {
                    id: post.user.id,
                    username: post.user.username
                },
                reaction_counts: post_reactions
            }
        }, status: :ok
    end

    def create
        post = Post.new(post_params)

        if post.save
            render json: post, status: :created
        else
            render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
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
end
