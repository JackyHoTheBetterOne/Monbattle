class AddMoreGbattleWeightToBattleLevels < ActiveRecord::Migration
  def change
    add_column :battle_levels, :gbattle_weight_scaling, :integer, default: 0
    add_column :battle_levels, :gbattle_weight_time, :integer, default: 0
  end
end
