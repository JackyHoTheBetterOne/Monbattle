class AddRewardBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :mp_reward, :integer, default: 0
    add_column :battle_levels, :gp_reward, :integer, default: 0
    remove_column :battle_levels, :item_given
  end
end
