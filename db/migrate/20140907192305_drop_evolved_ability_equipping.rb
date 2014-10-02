class DropEvolvedAbilityEquipping < ActiveRecord::Migration
  def change
    drop_table :evolved_ability_equippings
  end
end
