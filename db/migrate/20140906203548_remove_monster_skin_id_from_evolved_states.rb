class RemoveMonsterSkinIdFromEvolvedStates < ActiveRecord::Migration
  def change
    remove_reference :evolved_states, :monster_skin_id, index: true
  end
end
