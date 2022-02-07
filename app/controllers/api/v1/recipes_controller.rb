class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:create]

  def create
    Recipe.transaction do
      recipe = Recipe.create!(recipe_params)
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
  end

  private

    def recipe_params
      params.permit(:title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :image_key)
    end
end
