class AddIndexTagIdToWord < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :tag_id, unique: true
  end
end
