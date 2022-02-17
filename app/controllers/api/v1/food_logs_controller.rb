class Api::V1::FoodLogsController < ApplicationController
  def create
    current_user = current_api_v1_user
    if !current_user
      raise "You need to sign in or sign up before continuing."
    end
    food_logs = []
    food_log_templates = []
    for food_log in params[:food_logs] do
      food_logs.push({
        name: food_log[:name],
        calorie: food_log[:calorie],
        amount: food_log[:amount],
        meal_date_time: Time.parse(food_log[:meal_date_time]),
        recipe_id: food_log[:recipe_id]
      })
      if food_log[:is_create_template]
        food_log_templates.push({
          name: food_log[:name],
          calorie: food_log[:calorie],
          recipe_id: food_log[:recipe_id]
        })
      end
    end
    User.transaction do
      user = User.find(current_user.id)
      user.food_logs.create!(food_logs)
      if food_log_templates.length >= 1
        user.food_log_templates.create!(food_log_templates)
      end
    end
    render json: { message: 'Created' }, status: 201
  end

  def destroy
    current_user = current_api_v1_user
    if !current_user
      raise "You need to sign in or sign up before continuing."
    end
    current_user.food_logs.destroy(params[:id])
  end
end
