class Meal < ApplicationRecord
  belongs_to :category
  belongs_to :area
end
