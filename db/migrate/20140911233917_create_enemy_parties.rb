class CreateEnemyParties < ActiveRecord::Migration
  def change
    create_table :enemy_parties do |t|
      t.references :battle_level, index: true

      t.timestamps
    end
  end
end
