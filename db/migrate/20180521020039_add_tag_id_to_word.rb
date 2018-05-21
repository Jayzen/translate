class AddTagIdToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :tag_id, :integer
  end
end
