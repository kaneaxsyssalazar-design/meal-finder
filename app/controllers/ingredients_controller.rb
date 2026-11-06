class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.order(:name).page(params[:page]).per(30)
  end

  def show
    @ingredient = Ingredient.find(params[:id])
    @meals = @ingredient.meals.includes(:category, :area).order(:name).page(params[:page]).per(12)
  end
end
