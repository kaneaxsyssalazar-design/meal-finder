class TagsController < ApplicationController
  def index
    @tags = Tag.order(:name)
  end

  def show
    @tag = Tag.find(params[:id])
    @meals = @tag.meals.includes(:category, :area).order(:name).page(params[:page]).per(12)
  end
end
