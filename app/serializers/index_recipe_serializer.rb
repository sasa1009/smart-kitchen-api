class IndexRecipeSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :id, :title, :calorie, :main_ingredient, :category, :image_url
end
