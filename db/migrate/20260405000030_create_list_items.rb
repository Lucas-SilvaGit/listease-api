class CreateListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true
      t.references :product, foreign_key: true
      t.string :name_snapshot, null: false
      t.string :brand_snapshot
      t.decimal :quantity, precision: 10, scale: 2, null: false, default: 1
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0
      t.boolean :purchased, null: false, default: false

      t.timestamps
    end

    add_index :list_items, [:list_id, :purchased]
    add_index :list_items, :name_snapshot
  end
end

