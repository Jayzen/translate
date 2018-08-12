class RemoveTagTable < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :tags, :users
    drop_table :tags
    remove_index :words, :tag_id
    remove_column :words, :tag_id
  end
end
