class AddLevelToAbilityPurchase < ActiveRecord::Migration
  def change
    add_column :ability_purchases, :level, :integer, default: 1
  end
end
