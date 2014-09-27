class AddAbilSocketToAbilities < ActiveRecord::Migration
  def change
    add_reference :abilities, :abil_socket, index: true
    add_reference :ability_equippings, :monster_unlock, index: true
    remove_reference :ability_equippings, :user, index: true
    remove_reference :ability_equippings, :monster, index: true
  end
end
