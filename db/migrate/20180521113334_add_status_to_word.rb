class AddStatusToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :status, :boolean, default: false
  end
end
