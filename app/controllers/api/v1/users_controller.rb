class Api::V1::UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    render json: User.find(user_params[:id])
  end

  private

    def user_params
      params.permit(:id)
    end
end
