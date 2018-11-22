class AddConfirmTokenUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirm_token, :string
    add_index :users, :confirm_token, unique: true
  end
end
