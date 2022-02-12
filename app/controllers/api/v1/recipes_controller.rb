class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:create]

  def index
    recipes = nil
    count = nil

    # カテゴリーによる絞り込みが設定されている場合
    if params[:category] != ''
      recipes = Recipe.where(category: params[:category]).includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.where(category: params[:category]).count

    # メイン食材による絞り込みが設定されている場合
    elsif params[:main_ingredient] != ''
      recipes = Recipe.where(main_ingredient: params[:main_ingredient]).includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.where(main_ingredient: params[:main_ingredient]).count

    # 絞り込みなしの場合
    else
      recipes = Recipe.includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.count
    end

    # ログイン中の場合はユーザー情報を取得
    current_user = current_api_v1_user

    # JSONデータを整形
    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      recipes,
      includes: '**',
      each_serializer: IndexRecipeSerializer,
      current_user: current_user,
      meta: { total: count }
    )
    render json: serializable_resource.as_json
  end

  def create
    recipe = nil
    User.transaction do
      user = User.find_by(uid: request.headers[:uid])
      recipe = user.recipes.create!(recipe_params)
      ingredients = []
      for ingredient in params[:ingredients] do
        ingredients.push(ingredient.permit!.to_hash)
      end
      recipe.ingredients.create!(ingredients)
      procedures = []
      for procedure in params[:procedures] do
        procedures.push(procedure.permit!.to_hash)
      end
      recipe.procedures.create!(procedures)
    end
    render json: { id: recipe[:id] }, status: 201
  end

  def show
    recipe = Recipe.find(params[:id])

    # ログイン中の場合はユーザー情報を取得
    current_user = current_api_v1_user

    # JSONデータを整形
    serializable_resource = ActiveModelSerializers::SerializableResource.new(
      recipe,
      includes: '**',
      serializer: RecipeSerializer,
      current_user: current_user,
    )

    render json: serializable_resource.as_json
  end

  private

    def recipe_params
      params.permit(:title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :image_key)
    end
end
