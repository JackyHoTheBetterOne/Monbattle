class CreateMonsterSkins < ActiveRecord::Migration
  def change
    create_table :monster_skins do |t|
      t.text :skin_url
      t.string :name
      t.string :type
      t.string :class

      t.timestamps
    end
  end
end
