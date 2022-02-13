class IndexRecipeSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :id, :title, :calorie, :main_ingredient, :category, :image_url, :is_favorited, :favorited_count

  def is_favorited
    current_user = @instance_options[:current_user]
    if !!current_user
      user = object.favorites.find do |favorite|
        favorite[:user_id] == current_user[:id]
      end
      if !!user
        true
      else
        false
      end
    else
      false
    end
  end

  def favorited_count
    object.favorites.length
  end
end
