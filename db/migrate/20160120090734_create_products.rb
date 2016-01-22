class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :status
      t.string :name
      t.text :description
      t.belongs_to :brand
      t.belongs_to :category

      t.timestamps null: false
    end
  end
end
