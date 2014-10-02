class CreateMonsterSkinEquippings < ActiveRecord::Migration
  def change
    create_table :monster_skin_equippings do |t|
      t.references :monster, index: true
      t.references :monster_skin, index: true

      t.timestamps
    end
  end
end
