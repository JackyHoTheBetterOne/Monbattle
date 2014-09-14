class DropEnemyMembers < ActiveRecord::Migration
  def change
    drop_table :enemy_members
  end
end
