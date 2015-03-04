class RevampRewardOnBattleLevels < ActiveRecord::Migration
  def change
    remove_column :battle_levels, :mp_reward
    remove_column :battle_levels, :gp_reward
    remove_column :battle_levels, :vk_reward
    remove_column :battle_levels, :asp_reward
    remove_column :battle_levels, :enh_reward
    add_column :battle_levels, :time_reward, :text, default: [], array: true
    add_column :battle_levels, :pity_reward, :text, default: [], array: true
  end
end
