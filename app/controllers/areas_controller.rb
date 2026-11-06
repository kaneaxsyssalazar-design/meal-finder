class AreasController < ApplicationController
  def index
    @areas = Area.order(:name)
  end

  def show
    @area = Area.find(params[:id])
    @meals = @area.meals.includes(:category, :area).order(:name).page(params[:page]).per(12)
  end
end
