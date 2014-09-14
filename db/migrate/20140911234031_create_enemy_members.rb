class CreateEnemyMembers < ActiveRecord::Migration
  def change
    create_table :enemy_members do |t|
      t.references :monster_id, index: true
      t.references :enemy_party, index: true

      t.timestamps
    end
  end
end
