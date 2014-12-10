class AddAchievementEarnedToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :completed_daily_quests, :text, array: true
    add_column :summoners, :completed_weekly_quests, :text, array: true
    add_column :summoners, :completed_quests, :text, array: true
  end
end
