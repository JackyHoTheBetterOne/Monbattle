class AddMaxLvlToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :max_lvl, :integer
  end
end
