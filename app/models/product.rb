class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :brand_id, presence: true
  validates :category_id, presence: true
  has_many :product_sizes
  belongs_to :brand
  belongs_to :category
end
