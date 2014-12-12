class ChangeUnlockToUnlockedBy < ActiveRecord::Migration
  def change
    rename_column :battle_levels, :unlock_id, :unlocked_by_id
    rename_column :regions, :unlock_id, :unlocked_by_id
    rename_column :areas, :unlock_id, :unlocked_by_id
  end
end
