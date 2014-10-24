class ChangeReferencesMonsterskinequippings < ActiveRecord::Migration
  def change
    add_reference :monster_skin_equippings, :user, index: true
    add_reference :monster_skin_equippings, :monster, index: true
    remove_reference :monster_skin_equippings, :monster_unlock, index: true
  end
end
