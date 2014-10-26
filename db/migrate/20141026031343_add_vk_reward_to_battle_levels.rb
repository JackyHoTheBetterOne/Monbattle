class AddVkRewardToBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :vk_reward, :integer, default: 0
  end
end
