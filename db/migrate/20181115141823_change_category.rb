class ChangeCategory < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :posts, :categories

    create_join_table :posts, :categories do |t|
      t.index :post_id
      t.index :category_id
    end

    add_foreign_key :categories_posts, :posts, on_delete: :cascade
    add_foreign_key :categories_posts, :categories, on_delete: :cascade
  end
end
