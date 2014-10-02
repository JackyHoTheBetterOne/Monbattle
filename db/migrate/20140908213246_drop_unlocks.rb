class DropUnlocks < ActiveRecord::Migration
  def change
    drop_table :unlocks
  end
end
