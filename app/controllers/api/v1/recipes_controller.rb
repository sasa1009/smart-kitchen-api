class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:create]

  def index
    recipes = nil
    count = nil
    if params[:category] != ''
      recipes = Recipe.where(category: params[:category]).includes(:user).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.where(category: params[:category]).count
    elsif params[:main_ingredient] != ''
      recipes = Recipe.where(main_ingredient: params[:main_ingredient]).includes(:user).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.where(main_ingredient: params[:main_ingredient]).count
    else
      recipes = Recipe.includes(:user).limit(params[:limit]).offset(params[:offset]).order('updated_at DESC')
      count = Recipe.count
    end
    render json: recipes, meta: { total: count }, each_serializer: IndexRecipeSerializer
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
    render json: recipe, serializer: RecipeSerializer
  end

  private

    def recipe_params
      params.permit(:title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :image_key)
    end
end
