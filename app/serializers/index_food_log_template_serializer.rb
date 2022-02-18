class IndexFoodLogTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :calorie, :recipe_id
end
