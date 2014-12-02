class AddDescriptionAndVictoryMessageToBattles < ActiveRecord::Migration
  def change
    add_column :battle_levels, :description, :text
    add_column :battle_levels, :victory_message, :text
    add_column :battle_levels, :ability_reward, :text, array: true, default: []
  end
end
