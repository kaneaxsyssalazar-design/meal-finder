class MealTag < ApplicationRecord
  belongs_to :meal
  belongs_to :tag
  validates :tag_id, uniqueness: { scope: :meal_id }          # no duplicate tag per meal
  validates :meal, presence: true
end
