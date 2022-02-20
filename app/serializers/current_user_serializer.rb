class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :comment, :image_url, :following_count, :follower_count, :is_set_weight_loss_target, :height, :weight, :sex, :age, :activity_amount, :weight_loss_target

  def following_count
    return object.followings.count
  end

  def follower_count
    return object.followers.count
  end
end
