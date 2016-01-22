class Category < ActiveRecord::Base
  validates :name, presence: true
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id"
  belongs_to :parent_category, class_name: "Category"
end
