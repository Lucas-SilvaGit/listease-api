class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :brand
      t.string :category
      t.decimal :default_price, precision: 10, scale: 2

      t.timestamps
    end

    add_index :products, [:user_id, :name]
    add_index :products, [:user_id, :category]
  end
end

