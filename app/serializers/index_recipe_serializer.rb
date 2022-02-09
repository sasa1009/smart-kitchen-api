class IndexRecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :calorie, :main_ingredient, :category, :image_url, :image_key
end
