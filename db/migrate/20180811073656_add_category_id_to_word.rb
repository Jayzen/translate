class AddCategoryIdToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :category_id, :integer
    add_index :words, :category_id
  end
end
