class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:create]

  def index
    recipes = nil
    count = nil

    # 検索キーワードによる絞り込みが設定されている場合
    if params[:search_keyword] != ''
      q = Recipe.ransack(title_cont: params[:search_keyword], main_ingredient_cont: params[:search_keyword], category_cont: params[:search_keyword], ingredients_name_cont: params[:search_keyword], m: 'or')
      
      recipes = q.result(distinct: true).includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = q.result(distinct: true).count
    # カテゴリーによる絞り込みが設定されている場合
    elsif params[:category] != ''
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

  def user
    recipes = Recipe.where(user_id: params[:user_id]).includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
    count = Recipe.where(user_id: params[:user_id]).count

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

  def favorite
    user = User.find(params[:user_id])
    recipes = user.favorited_recipes.includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
    count = user.favorited_recipes.count

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

  def ranking
    recipe_ids = Favorite.connection.select_all("
      SELECT COUNT(id) AS id_count, recipe_id
      FROM favorites
      WHERE created_at BETWEEN '#{params[:from]}' AND '#{params[:to]}'
      GROUP BY recipe_id
      ORDER BY id_count DESC
      LIMIT #{params[:limit].to_i}
      OFFSET #{params[:offset].to_i}"
    ).pluck('recipe_id')
    p recipe_ids

    recipes = Recipe.find_by_sql(["
      SELECT
        recipes.id,
        recipes.title,
        recipes.calorie,
        recipes.main_ingredient,
        recipes.category,
        recipes.image_url,
        recipes.updated_at,
        users.id AS user_id,
        users.name AS user_name,
        users.image_url AS user_image_url,
        (
          SELECT COUNT(*)
          FROM favorites
          WHERE favorites.recipe_id = recipes.id
        ) AS favorited_count
      FROM recipes
      LEFT JOIN users
      ON recipes.user_id = users.id
      WHERE recipes.id IN(?)
      ORDER BY favorited_count DESC, updated_at DESC",
      recipe_ids
    ])

    count = Recipe.where(id: recipe_ids).count

    # # ログイン中の場合はユーザー情報を取得
    current_user = current_api_v1_user
    current_user_favorites = nil
    if !!current_user
      current_user_favorites = current_user.favorites
    end

    # レスポンスデータを作成
    response_data = {
      recipes: [],
      meta: {
        total: count
      }
    }

    for recipe in recipes do
      if !!current_user
        favorite = current_user_favorites.find do |favorite|
          favorite[:recipe_id] === recipe[:id]
        end
        response_data[:recipes].push({
          id: recipe[:id],
          title: recipe[:title],
          calorie: recipe[:calorie],
          main_ingredient: recipe[:main_ingredient],
          category: recipe[:category],
          image_url: recipe[:image_url],
          is_favorited: !!favorite,
          favorited_count: recipe[:favorited_count],
          user: {
            id: recipe[:user_id],
            name: recipe[:user_name],
            image_url: recipe[:user_image_url],
          }
        })
      else
        response_data[:recipes].push({
          id: recipe[:id],
          title: recipe[:title],
          calorie: recipe[:calorie],
          main_ingredient: recipe[:main_ingredient],
          category: recipe[:category],
          image_url: recipe[:image_url],
          is_favorited: false,
          favorited_count: recipe[:favorited_count],
          user: {
            id: recipe[:user_id],
            name: recipe[:user_name],
            image_url: recipe[:user_image_url],
          }
        })
      end
    end

    render json: response_data
  end

  def following
    user = User.find(params[:user_id])
    relationships = user.relationships.map{ |relationship| relationship[:follow_id] }
    recipes = Recipe.where('user_id IN (?)', relationships).includes(:user, :favorites).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
    count = Recipe.where('user_id IN (?)', relationships).count

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

  private

    def recipe_params
      params.permit(:title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :image_key)
    end
end
