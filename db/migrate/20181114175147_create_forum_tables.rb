class CreateForumTables < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :categoryName, null: false, unique: true
    end

    add_index :categories, :categoryName, unique: true

    create_table :posts do |t|
      t.string :postTitle, null: false
      t.bigint :user_id, null: false
      t.text :postText, null: false
      t.timestamp :postDate, null: false
      t.bigint :category_id, null: false
    end

    add_foreign_key :posts, :users, on_delete: :cascade
    add_foreign_key :posts, :categories, on_delete: :cascade
  end
end
