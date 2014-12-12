class DeleteUnlockedByDefault < ActiveRecord::Migration
  def change
    remove_column :regions, :unlocked_by_default
    remove_column :areas, :unlocked_by_default
    remove_column :battle_levels, :unlocked_by_default
  end
end
