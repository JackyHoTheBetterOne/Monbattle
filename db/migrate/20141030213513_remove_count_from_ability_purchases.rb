class RemoveCountFromAbilityPurchases < ActiveRecord::Migration
  def change
    remove_column :ability_purchases, :amount_owned
  end
end
