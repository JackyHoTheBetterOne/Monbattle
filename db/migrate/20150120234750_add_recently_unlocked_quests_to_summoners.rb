class AddRecentlyUnlockedQuestsToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :just_achieved_quests, :text, array: true, default: []
  end
end
