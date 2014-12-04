class ChangeDefaultOnAbilityReward < ActiveRecord::Migration
  def change
    remove_column :battle_levels, :ability_reward
  end
end
