class ChangeCategoriesColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :categories, :weight, :integer, default: 0
  end
end
