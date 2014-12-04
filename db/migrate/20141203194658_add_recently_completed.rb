class AddRecentlyCompleted < ActiveRecord::Migration
  def change
    add_column :summoners, :recently_completed_quests, :text, array: true, default: []
    add_column :summoners, :recently_unlocked_levels, :text, array: true, default: []
    change_column :summoners, :completed_daily_quests, :text, array: true, default: []
    change_column :summoners, :completed_weekly_quests, :text, array: true, default: []
    change_column :summoners, :completed_quests, :text, array: true, default: []
    change_column :summoners, :beaten_levels, :text, array: true, default: []
  end
end
