class RecipeSerializer < ActiveModel::Serializer
  belongs_to :user
  has_many :ingredients
  has_many :procedures

  attributes :id, :title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :is_favorited

  def is_favorited
    current_user = @instance_options[:current_user]
    if !!current_user
      object.favorites.exists?(user_id: current_user.id)
    else
      false
    end
  end
end
