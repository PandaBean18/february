class Api::V1::MediaController < ApplicationController
    def signature
        timestamp = Time.now.to_i

        folder_name = case params[:type]
        when "profile_picture" then "flopin_avatars"
        when "sticker"           then "flopin_stickers"
        else "flopin_general"
        end

        params_to_sign = {
            timestamp: timestamp,
            folder: folder_name
        }

        signature = Cloudinary::Utils.api_sign_request(params_to_sign, Cloudinary.config.api_secret)

        render json: {
            signature: signature,
            timestamp: timestamp,
            api_key: Cloudinary.config.api_key,
            cloud_name: Cloudinary.config.cloud_name,
            folder: folder_name
        }, status: :ok
    end
end
