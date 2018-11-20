class RemoveCategoryIdFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :category_id
  end
end
