class AddUnlockedByDefaultToBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :unlocked_by_default, :boolean
  end
end
