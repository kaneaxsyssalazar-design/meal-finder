class MealsController < ApplicationController
  def index
  meals = Meal.includes(:category, :area).order(:name)
  if params[:q].present?                                   # 4.1 text search
    like = "%#{Meal.sanitize_sql_like(params[:q])}%"
    meals = meals.where("meals.name LIKE ?", like)
  end
  meals = meals.where(category_id: params[:category_id]) if params[:category_id].present?  # 4.2
  @meals = meals.page(params[:page]).per(12)               # 3.5 pagination
  @categories = Category.order(:name)
end

def show
  @meal = Meal.find(params[:id])
end