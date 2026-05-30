class Api::V1::StickersController < ApplicationController
    def signature
        timestamp = Time.now.to_i

        params_to_sign = {
            timestamp: timestamp,
            folder: "flopin_stickers"
        }

        signature = Cloudinary::Utils.api_sign_request(params_to_sign, Cloudinary.config.api_secret)

        render json: {
            signature: signature,
            timestamp: timestamp,
            api_key: Cloudinary.config.api_key,
            cloud_name: Cloudinary.config.cloud_name,
            folder: "flopin_stickers"
        }, status: :ok
    end

    def create
        ActiveRecord::Base.transaction do
            medium = Medium.create!(media_type: :sticker, cloudinary_public_id: sticker_params[:cloudinary_public_id])
            sticker = Sticker.create!(medium: medium, user_id: sticker_params[:user_id], name: sticker_params[:name])

            render json: {
                sticker_id: sticker.id,
                name: sticker.name,
                url: medium.cloudinary_url,
                creator_id: sticker.user_id
            }, status: :created
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: [ e.message ] }, status: :unprocessable_entity
    end

    private

    def sticker_params
        params.require(:sticker).permit(:user_id, :name, :cloudinary_public_id)
    end
end
