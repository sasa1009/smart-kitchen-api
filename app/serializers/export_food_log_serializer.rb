class ExportFoodLogSerializer < ActiveModel::Serializer
  attributes :id, :name, :calorie, :amount, :recipe_id, :meal_date_time, :user_id
end
