class CreateMonsterAssignments < ActiveRecord::Migration
  def change
    create_table :monster_assignments do |t|
      t.integer :monster_id
      t.integer :battle_level_id

      t.timestamps
    end
  end
end
