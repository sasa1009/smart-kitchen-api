class IndexFoodLogSerializer < ActiveModel::Serializer
  attributes :id, :name, :calorie, :recipe_id, :meal_date_time
end
