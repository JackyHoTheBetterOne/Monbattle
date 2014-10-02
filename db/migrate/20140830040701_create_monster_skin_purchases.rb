class CreateMonsterSkinPurchases < ActiveRecord::Migration
  def change
    create_table :monster_skin_purchases do |t|
      t.references :user, index: true
      t.references :monster_skin, index: true

      t.timestamps
    end
  end
end
