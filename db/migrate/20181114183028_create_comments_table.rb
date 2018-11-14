class CreateCommentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.bigint :user_id, null: false
      t.text :commentText, null: false
      t.timestamp :commentDate, null: false
    end

    add_foreign_key :comments, :users, on_delete: :cascade

    create_join_table :posts, :comments do |t|
      t.index :post_id
      t.index :comment_id
    end

    add_foreign_key :comments_posts, :posts, on_delete: :cascade
    add_foreign_key :comments_posts, :comments, on_delete: :cascade
  end
end
