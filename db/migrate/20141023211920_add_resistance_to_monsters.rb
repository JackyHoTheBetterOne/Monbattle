class AddResistanceToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :physical_resistance, :integer
    add_column :monsters, :ability_resistance, :integer
  end
end
