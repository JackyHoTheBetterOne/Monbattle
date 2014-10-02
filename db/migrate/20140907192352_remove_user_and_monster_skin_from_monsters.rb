class RemoveUserAndMonsterSkinFromMonsters < ActiveRecord::Migration
  def change
    remove_reference :monsters, :user, index: true
    remove_reference :monsters, :monster_skin, index: true
  end
end
