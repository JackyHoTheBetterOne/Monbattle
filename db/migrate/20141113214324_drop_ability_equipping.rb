class DropAbilityEquipping < ActiveRecord::Migration
  def change
    drop_table :ability_equippings
  end
end
