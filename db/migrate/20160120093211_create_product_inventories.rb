class CreateProductInventories < ActiveRecord::Migration
  def change
    create_table :product_inventories do |t|
      t.integer :status
      t.integer :cost_price
      t.integer :selling_price
      t.integer :quantity
      t.belongs_to :product_size
      t.belongs_to :property

      t.timestamps null: false
    end
  end
end
