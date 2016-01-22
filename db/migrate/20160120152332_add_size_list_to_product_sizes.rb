class AddSizeListToProductSizes < ActiveRecord::Migration
  def change
    add_reference :product_sizes, :size_list, index: true, foreign_key: true
  end
end
