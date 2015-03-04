class AddRewardToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :reward_num, :integer, default: 0
  end
end
