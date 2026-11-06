class Ingredient < ApplicationRecord
  has_many :meal_ingredients, dependent: :destroy
  has_many :meals, through: :meal_ingredients   # many-to-many with meals
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :ingredient_type, length: { maximum: 100 }, allow_blank: true
end
