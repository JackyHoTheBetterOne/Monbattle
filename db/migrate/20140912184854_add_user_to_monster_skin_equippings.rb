class AddUserToMonsterSkinEquippings < ActiveRecord::Migration
  def change
    add_reference :monster_skin_equippings, :user, index: true
  end
end
