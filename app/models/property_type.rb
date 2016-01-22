class PropertyType < ActiveRecord::Base
  validates :name, presence: true
end
