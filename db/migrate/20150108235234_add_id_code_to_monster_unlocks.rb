class AddIdCodeToMonsterUnlocks < ActiveRecord::Migration
  def change
    add_column :monster_unlocks, :id_code, :string
  end
end
