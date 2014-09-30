class AddMonsterUnlockMembers < ActiveRecord::Migration
  def change
    remove_reference :members, :monster, index: true
    add_reference :members, :monster_unlock, index: true
  end
end
