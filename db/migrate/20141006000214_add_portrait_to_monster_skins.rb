class AddPortraitToMonsterSkins < ActiveRecord::Migration
  def change
    add_attachment :monster_skins, :portrait
  end
end
