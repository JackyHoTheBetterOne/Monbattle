class CreateMonsterUnlocks < ActiveRecord::Migration
  def change
    create_table :monster_unlocks do |t|
      t.references :user, index: true
      t.references :monster, index: true

      t.timestamps
    end
  end
end
