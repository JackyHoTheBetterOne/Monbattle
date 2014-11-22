class RemoveRewardTypeFromQuests < ActiveRecord::Migration
  def change
    remove_column :quests, :reward_type
  end
end
