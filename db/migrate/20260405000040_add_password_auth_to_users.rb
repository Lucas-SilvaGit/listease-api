class AddPasswordAuthToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :google_uid, true
    add_column :users, :password_digest, :string
  end
end
