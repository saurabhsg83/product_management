class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :status
      t.string :name
      t.references :parent_category, index: true
      t.timestamps null: false
    end
  end
end
