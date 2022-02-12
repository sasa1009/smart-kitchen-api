class RecipeSerializer < ActiveModel::Serializer
  belongs_to :user
  has_many :ingredients
  has_many :procedures
  
  attributes :id, :title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url
end
