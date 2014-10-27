class AddAmountOwnedToAbilityPurchases < ActiveRecord::Migration
  def change
    add_column :ability_purchases, :amount_owned, :integer, default: 1
  end
end
