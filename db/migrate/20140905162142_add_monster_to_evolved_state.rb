class AddMonsterToEvolvedState < ActiveRecord::Migration
  def change
    add_reference :evolved_states, :monster, index: true
  end
end
