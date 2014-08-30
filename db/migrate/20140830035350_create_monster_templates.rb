class CreateMonsterTemplates < ActiveRecord::Migration
  def change
    create_table :monster_templates do |t|
      t.string :class
      t.string :type
      t.integer :max_hp
      t.integer :max_sp
      t.integer :max_lvl
      t.string :element

      t.timestamps
    end
  end
end
