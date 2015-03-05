class AddEventRewardTierToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :event_reward_tier, :string, default: ""
  end
end
