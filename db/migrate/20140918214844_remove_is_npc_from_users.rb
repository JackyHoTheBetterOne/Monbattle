class RemoveIsNpcFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_npc, :boolean
  end
end
