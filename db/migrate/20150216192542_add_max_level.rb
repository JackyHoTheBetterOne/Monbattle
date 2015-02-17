class AddMaxLevel < ActiveRecord::Migration
  def change
    add_column :monsters, :max_level, :integer, default: 10
    add_column :monster_unlocks, :level, :integer, default: 0
  end
end
