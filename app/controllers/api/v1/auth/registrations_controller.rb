class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def destroy
    # ユーザー情報取得
    user = current_api_v1_user
    if !user
      raise "You need to sign in or sign up before continuing."
    end

    if user[:image_key] != nil
      client = Aws::S3::Client.new
      client.delete_object({
        bucket: ENV['S3_BUCKET'], 
        key: user[:image_key],
      })
    end
    user.destroy!
  end

  private

    def sign_up_params
      params.permit(:email, :password, :password_confirmation, :name, :comment)
    end
end
