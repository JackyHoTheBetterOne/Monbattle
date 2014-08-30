class AddMonsterSkinToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :monster_skin, index: true
  end
end
