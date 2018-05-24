class AddVoiceToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :uk_voice, :string
    add_column :words, :us_voice, :string
  end
end
