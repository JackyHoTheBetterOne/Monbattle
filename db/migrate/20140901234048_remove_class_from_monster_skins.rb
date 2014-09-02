class RemoveClassFromMonsterSkins < ActiveRecord::Migration
  def change
    remove_column :monster_skins, :class
  end
end
