class AddWeightToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :weight, :datetime
  end
end
