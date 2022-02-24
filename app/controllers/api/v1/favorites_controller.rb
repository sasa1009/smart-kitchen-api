class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    favorite = nil
    User.transaction do
      user = User.find_by(uid: request.headers[:uid])
      favorite = user.favorites.create!(recipe_id: favorite_params[:recipe_id])
      recipe = Recipe.find(favorite_params[:recipe_id])
      Notification.create!(user_id: recipe[:user_id], sender_id: current_user[:id], recipe_id: favorite_params[:recipe_id])
    end
    render json: { id: favorite[:id] }, status: 201
  end

  def destroy
    current_user = current_api_v1_user
    favorite = current_user.favorites.find_by!(recipe_id: favorite_params[:recipe_id])
    favorite.destroy
  end

  private

    def favorite_params
      params.permit(:recipe_id)
    end
end
