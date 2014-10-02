class AddMonsterSkinToEvolvedStates < ActiveRecord::Migration
  def change
    add_reference :evolved_states, :monster_skin, index: true
  end
end
