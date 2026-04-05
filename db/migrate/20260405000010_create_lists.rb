class CreateLists < ActiveRecord::Migration[8.1]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :kind, null: false, default: "free"
      t.integer :month
      t.integer :year

      t.timestamps
    end

    add_index :lists, [:user_id, :kind]
    add_index :lists, [:user_id, :updated_at]
  end
end

