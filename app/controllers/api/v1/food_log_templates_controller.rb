class Api::V1::FoodLogTemplatesController < ApplicationController
  def index
    current_user = current_api_v1_user
    if !current_user
      raise "You need to sign in or sign up before continuing."
    end
    templates = current_user.food_log_templates.limit(params[:limit]).offset(params[:offset]).order('created_at DESC')
    count = current_user.food_log_templates.count
    render json: templates, each_serializer: IndexFoodLogTemplatesSerializer, meta: { total: count }
  end

  def destroy
    current_user = current_api_v1_user
    if !current_user
      raise "You need to sign in or sign up before continuing."
    end
    current_user.food_log_templates.destroy(params[:id])
  end
end
