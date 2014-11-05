class AddMonsterUnlocksToAbilityPurchases < ActiveRecord::Migration
  def change
    add_reference :ability_purchases, :monster_unlock, index: true
  end
end
