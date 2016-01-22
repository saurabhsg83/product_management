class ProductInventory < ActiveRecord::Base
  belongs_to :product_size
  belongs_to :property
  validates :cost_price, presence: true
  validates :selling_price, presence: true
  validates :quantity, presence: true
  validates :product_size_id, presence: true
end
