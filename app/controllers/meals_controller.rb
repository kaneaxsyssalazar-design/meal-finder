class MealsController < ApplicationController
  def index
    @categories = Category.order(:name)
    meals = Meal.includes(:category, :area).order(:name)

    # 4.1 text search: meal name OR any of its ingredient names
    if params[:q].present?
      like = "%#{Meal.sanitize_sql_like(params[:q])}%"
      meals = meals.where(
        "meals.name LIKE :q OR meals.id IN (
           SELECT meal_ingredients.meal_id FROM meal_ingredients
           INNER JOIN ingredients ON ingredients.id = meal_ingredients.ingredient_id
           WHERE ingredients.name LIKE :q)", q: like)
    end

    # 4.2 restrict the search to one category
    meals = meals.where(category_id: params[:category_id]) if params[:category_id].present?

    @meals = meals.page(params[:page]).per(12)   # 3.5 pagination
  end

  def show
    @meal = Meal.includes(:category, :area, :tags, meal_ingredients: :ingredient).find(params[:id])
  end

  # GET /meals/random - jump to a random meal
  def random
    redirect_to Meal.order(Arel.sql("RANDOM()")).first
  end
end
