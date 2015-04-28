class ChangeTurnIndexToFloat < ActiveRecord::Migration
  def change
    change_column :battle_levels, :gbattle_weight_scaling, :float
  end
end
