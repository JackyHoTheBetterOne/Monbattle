class RemoveMaxLvlFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :max_lvl, :string
  end
end
