class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.integer :status
      t.belongs_to :property_type, index: true
      t.timestamps null: false
    end
  end
end
