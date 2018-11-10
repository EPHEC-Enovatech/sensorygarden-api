class AddConfirmToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirm_email, :boolean, default: 'false'
  end
end
