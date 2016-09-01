class UniqueLogin < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :login, false
    add_index :users, :login, unique: true

    change_column_null :users, :name, false
    change_column_null :users, :password_digest, false
  end
end
