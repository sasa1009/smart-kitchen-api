class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :comment, :image_url
end
