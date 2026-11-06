class Category < ApplicationRecord
  has_many :meals, dependent: :destroy   # one-to-many: a category has many meals
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
