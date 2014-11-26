class AddUnlockToBattleLevel < ActiveRecord::Migration
  def change
    add_column :battle_levels, :unlock_id, :integer, index: true
  end
end
