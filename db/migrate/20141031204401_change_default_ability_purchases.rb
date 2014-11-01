class ChangeDefaultAbilityPurchases < ActiveRecord::Migration
  def change
    remove_reference :ability_purchases, :monster_unlock
    add_reference :ability_purchases, :monster_unlock, index: true, default: 0
  end
end
