class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:update]

  def index
    render json: User.all
  end

  def followings
    user = User.find(user_params[:id])
    users = user.followings.limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
    count = user.followings.count

    # ログイン中の場合はrelationshipsを取得
    current_user = current_api_v1_user
    relationships = []
    if !!current_user
      relationships = current_user.relationships
    end

    # JSONデータを整形
    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      users,
      includes: '**',
      each_serializer: IndexUserSerializer,
      relationships: relationships,
      meta: { total: count }
    )
    render json: serializable_resource.as_json
  end

  def followers
    user = User.find(user_params[:id])
    users = user.followers.limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
    count = user.followers.count

    # ログイン中の場合はrelationshipsを取得
    current_user = current_api_v1_user
    relationships = []
    if !!current_user
      relationships = current_user.relationships
    end

    # JSONデータを整形
    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      users,
      includes: '**',
      each_serializer: IndexUserSerializer,
      relationships: relationships,
      meta: { total: count }
    )
    render json: serializable_resource.as_json
  end

  def show
    user = User.find(user_params[:id])

    # ログイン中の場合はユーザー情報を取得
    current_user = current_api_v1_user

    # JSONデータを整形
    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      user,
      includes: '**',
      serializer: UserSerializer,
      current_user: current_user,
    )
    render json: serializable_resource.as_json
  end

  def update
    user = User.find(user_params[:id])
    if update_user_params.has_key?(:image_url) && update_user_params.has_key?(:image_key) && user[:image_key] != nil
      client = Aws::S3::Client.new
      client.delete_object({
        bucket: ENV['S3_BUCKET'], 
        key: user[:image_key],
      })
    end
    user.update(update_user_params)
    render json: user, serializer: CurrentUserSerializer
  end

  private

    def user_params
      params.permit(:id)
    end

    def update_user_params
      params.permit(:name, :comment, :image_url, :image_key, :is_set_weight_loss_target, :height, :weight, :sex, :age, :activity_amount, :weight_loss_target)
    end
end
