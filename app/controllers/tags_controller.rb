class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end

  def show
    @category = Category.find(params[:id])
    @meals = @category.meals.includes(:category, :area).order(:name).page(params[:page]).per(12)
  end
end