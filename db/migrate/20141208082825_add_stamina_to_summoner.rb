class AddStaminaToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :stamina, :integer, default: 100
    add_column :battle_levels, :stamina_cost, :integer, default: 0
  end
end
