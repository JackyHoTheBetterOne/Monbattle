class AddSocketNumToAbilityPurchases < ActiveRecord::Migration
  def change
    add_column :ability_purchases, :socket_num, :integer
  end
end
