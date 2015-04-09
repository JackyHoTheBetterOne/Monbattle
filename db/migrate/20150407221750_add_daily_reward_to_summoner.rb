class AddDailyRewardToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :daily_reward_given_first, :boolean, default: false
    add_column :summoners, :daily_reward_given_second, :boolean, default: false
    add_column :summoners, :daily_reward_giving_time, :datetime
  end
end
