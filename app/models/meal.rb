class Meal < ApplicationRecord
  belongs_to :category                          # many meals -> one category
  belongs_to :area                              # many meals -> one area

  has_many :meal_ingredients, dependent: :destroy
  has_many :ingredients, through: :meal_ingredients   # many-to-many

  has_many :meal_tags, dependent: :destroy
  has_many :tags, through: :meal_tags                 # many-to-many

  validates :name, presence: true
  validates :instructions, presence: true
  validates :external_id, presence: true, uniqueness: true
end
