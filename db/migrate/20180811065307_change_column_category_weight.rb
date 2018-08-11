class ChangeColumnCategoryWeight < ActiveRecord::Migration[5.2]
  def change
    change_column :categories, :weight, :datetime
  end
end
