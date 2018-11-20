class ChangeComments < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :posts, :comments

    add_column :comments, :post_id, :bigint
    add_foreign_key :comments, :posts
  end
end
