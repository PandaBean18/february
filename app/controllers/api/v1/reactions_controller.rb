class Api::V1::ReactionsController < ApplicationController
    def create
        post = Post.find(params[:post_id])
        reaction = post.reaction.find_or_initialize_by(user_id: reaction_params[:user_id])
        reaction.reaction_type = reaction_params[:reaction_type]

        if reaction.save
            render json: reaction, status: reaction.previously_new_record? ? :created : :ok
        else
            puts reaction.errors.full_messages
            render json: { errors: reaction.errors.full_messages }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
    end

    private

    def reaction_params
        params.require(:reaction).permit(:user_id, :reaction_type)
    end
end
