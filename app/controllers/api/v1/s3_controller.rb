class Api::V1::S3Controller < ApplicationController
  before_action :authenticate_api_v1_user!

  def presigned_url
    signer = Aws::S3::Presigner.new
    key = "#{user_params[:userId]}/#{SecureRandom.uuid}/#{user_params[:fileName]}"
    url = signer.presigned_url(
      :put_object, 
      bucket: ENV['S3_BUCKET'],
      key: key
    )
    render json: { url: url, key: key }
  end

  private

    def user_params
      params.permit(:userId, :fileName)
    end
end
