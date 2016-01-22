class CreateProductSizes < ActiveRecord::Migration
  def change
    create_table :product_sizes do |t|
      t.integer :status
      t.belongs_to :product

      t.timestamps null: false
    end
  end
end
