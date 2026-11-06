class Tag < ApplicationRecord
  has_many :meal_tags, dependent: :destroy
  has_many :meals, through: :meal_tags          # many-to-many with meals
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
