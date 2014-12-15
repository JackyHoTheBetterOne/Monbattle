class AddDefaultToRecentlyUnlockedLevel < ActiveRecord::Migration
  def change
    remove_column :summoners, :recently_unlocked_level
    add_column :summoners, :recently_unlocked_level, :string, default: ""
  end
end
