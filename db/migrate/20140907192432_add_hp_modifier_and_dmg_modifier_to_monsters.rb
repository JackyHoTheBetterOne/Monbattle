class AddHpModifierAndDmgModifierToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :hp_modifier, :integer
    add_column :monsters, :dmg_modifier, :integer
  end
end
