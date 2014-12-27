class AddBackgroundAndMusicToLevel < ActiveRecord::Migration
  def change
    add_column :battle_levels, :background, :string
    add_column :battle_levels, :music, :string
  end
end
