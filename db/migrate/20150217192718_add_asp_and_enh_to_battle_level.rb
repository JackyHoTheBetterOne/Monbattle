class AddAspAndEnhToBattleLevel < ActiveRecord::Migration
  def change
    add_column :battle_levels, :asp_reward, :integer, default: 0
    add_column :battle_levels, :enh_reward, :integer, default: 0
  end
end
