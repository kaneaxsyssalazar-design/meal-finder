class Area < ApplicationRecord
  has_many :meals, dependent: :destroy   # one-to-many: an area has many meals
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :latitude,  numericality: { greater_than_or_equal_to: -90,  less_than_or_equal_to: 90 },  allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
end
