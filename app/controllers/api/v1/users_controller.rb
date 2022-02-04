class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:edit]

  def index
    render json: User.all
  end

  def show
    render json: User.find(user_params[:id])
  end

  def update
    user = User.find(user_params[:id])
    user.update(update_user_params)
    render json: user, serializer: UserSerializer
  end

  private

    def user_params
      params.permit(:id)
    end

    def update_user_params
      params.permit(:name, :comment, :image_url, :image_key, :user)
    end
end
