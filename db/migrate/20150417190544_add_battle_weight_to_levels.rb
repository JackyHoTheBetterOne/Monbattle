class AddBattleWeightToLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :gbattle_weight_base, :integer, default: 0
    add_column :battle_levels, :gbattle_weight_turn, :integer, default: 0
  end
end
