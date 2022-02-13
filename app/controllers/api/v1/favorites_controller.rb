class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    current_user = current_api_v1_user
    favorite = current_user.favorites.create!(recipe_id: favorite_params[:recipe_id])
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
