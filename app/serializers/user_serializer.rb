class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :comment, :image_url, :is_following, :is_followed, :following_count, :follower_count

  def is_following
    current_user = @instance_options[:current_user]
    if !!current_user
      return current_user.following?(object)
    else
      return false
    end
  end

  def is_followed
    current_user = @instance_options[:current_user]
    if !!current_user
      return object.following?(current_user)
    else
      return false
    end
  end

  def following_count
    return object.followings.count
  end

  def follower_count
    return object.followers.count
  end
end
