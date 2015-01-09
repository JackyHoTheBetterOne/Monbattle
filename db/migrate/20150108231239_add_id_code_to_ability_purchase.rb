class AddIdCodeToAbilityPurchase < ActiveRecord::Migration
  def change
    add_column :ability_purchases, :id_code, :string
  end
end
