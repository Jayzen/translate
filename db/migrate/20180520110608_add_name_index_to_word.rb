class AddNameIndexToWord < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :name
  end
end
