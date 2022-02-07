class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:create]

  def create
    Recipe.transaction do
      recipe = Recipe.create!(recipe_params)
      p recipe
      for ingredient in params[:ingredients] do
        recipe.ingredients.create!(index: ingredient[:index], name: ingredient[:name], amount: ingredient[:amount])
      end
      for procedure in params[:procedures] do
        recipe.procedures.create!(index: procedure[:index], description: procedure[:description], image_url: procedure[:image_url], image_key: procedure[:image_key])
      end
    end
  end

  private

    def recipe_params
      params.permit(:title, :comment, :amount, :calorie, :main_ingredient, :category, :tips, :image_url, :image_key)
    end
end
