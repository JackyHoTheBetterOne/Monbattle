class ChangeAbilityEquippingReference < ActiveRecord::Migration
  def change
    remove_reference :ability_equippings, :ability
    add_reference :ability_equippings, :ability_purchase, index: true
  end
end
