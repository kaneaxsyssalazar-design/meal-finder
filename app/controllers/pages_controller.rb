class PagesController < ApplicationController
  # GET /  - the home page
  def home
    @categories   = Category.order(:name)
    # RANDOM() is SQLite's random order; Arel.sql marks the fragment as safe
    @random_meals = Meal.includes(:category, :area).order(Arel.sql("RANDOM()")).limit(8)
  end

  # GET /about
  def about
  end
end
