class Repeat < ActiveRecord::Migration
  def change
    add_column :monster_skins, :painter, :string
  end
end
