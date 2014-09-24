class AddSummonCostToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :summon_cost, :integer
  end
end
