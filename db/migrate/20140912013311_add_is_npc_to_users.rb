class AddIsNpcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_npc, :boolean, default: false
  end
end
