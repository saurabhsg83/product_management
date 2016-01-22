class ProductSize < ActiveRecord::Base
  belongs_to :product
  has_many :product_inventories
  belongs_to :size_list, :foreign_key => 'size_id'
end
