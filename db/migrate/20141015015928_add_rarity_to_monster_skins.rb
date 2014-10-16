class AddRarityToMonsterSkins < ActiveRecord::Migration
  def change
    add_reference :monster_skins, :rarity, index: true
  end
end
