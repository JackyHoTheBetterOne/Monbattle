class AddAbilityRewardAgain < ActiveRecord::Migration
  def change
    add_column :battle_levels, :ability_reward, :text, array: true, default: []
  end
end
