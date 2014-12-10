class ChangeRecentlyUnlockedLevelsOnSummoners < ActiveRecord::Migration
  def change
    remove_column :summoners, :recently_unlocked_levels
    add_column :summoners, :recently_unlocked_level, :string, default: nil
  end
end
