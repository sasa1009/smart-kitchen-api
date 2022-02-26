class Api::V1::RelationshipsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    current_user = current_api_v1_user
    relationship = nil
    User.transaction do
      user = User.find(relationship_params[:user_id])
      relationship = current_user.follow(user)
      user.notifications.create!(sender_id: current_user[:id], recipe_id: nil)
    end
    render json: { id: relationship[:id] }, status: 201
  end

  def destroy
    current_user = current_api_v1_user
    user = User.find(relationship_params[:user_id])
    current_user.unfollow(user)
  end

  private

    def relationship_params
      params.permit(:user_id)
    end
end
