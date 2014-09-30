class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :max_hp
      t.integer :max_ap
      t.references :user, index: true
      t.references :template, index: true
      t.string :type
      t.string :class
      t.string :element
      t.integer :exp

      t.timestamps
    end
  end
end
