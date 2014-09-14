class DropEnemyParties < ActiveRecord::Migration
  def change
    drop_table :enemy_parties
  end
end
