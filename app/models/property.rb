class Property < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :property_type
  has_many :product_inventories
end
