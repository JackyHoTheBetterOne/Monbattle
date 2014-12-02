class ChangeDefaultAgain < ActiveRecord::Migration
  def change
    change_column :battle_levels, :ability_reward, :text, default: []
  end
end
