class AddForbiddenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forbidden, :boolean, default: false
  end
end
