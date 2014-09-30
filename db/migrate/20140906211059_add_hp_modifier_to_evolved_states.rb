class AddHpModifierToEvolvedStates < ActiveRecord::Migration
  def change
    add_column :evolved_states, :hp_modifier, :integer
  end
end
