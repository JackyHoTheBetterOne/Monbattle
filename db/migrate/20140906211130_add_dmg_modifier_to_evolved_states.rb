class AddDmgModifierToEvolvedStates < ActiveRecord::Migration
  def change
    add_column :evolved_states, :dmg_modifier, :integer
  end
end
