class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :name
      t.string :uk
      t.string :us
      t.string :chinese
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
