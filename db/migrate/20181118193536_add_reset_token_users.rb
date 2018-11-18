class AddResetTokenUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reset_token, :string
    add_index :users, :reset_token, unique: true
  end
end
