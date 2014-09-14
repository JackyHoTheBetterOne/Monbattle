class MonsterSkin < ActiveRecord::Migration
  def change
    add_attachment :monster_skins, :avatar
  end
end
