class ChangeDefaultNamesMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :default_skin
    remove_column :monsters, :default_abil_socket1
    remove_column :monsters, :default_abil_socket2
    add_column :monsters, :default_skin_id, :integer
    add_column :monsters, :default_sock1_id, :integer
    add_column :monsters, :default_sock2_id, :integer
  end
end
