class RemoveClassFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :class
  end
end
