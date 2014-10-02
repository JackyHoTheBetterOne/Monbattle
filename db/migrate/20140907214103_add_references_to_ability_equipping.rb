class AddReferencesToAbilityEquipping < ActiveRecord::Migration
  def change
    add_reference :ability_equippings, :user, index: true
  end
end
