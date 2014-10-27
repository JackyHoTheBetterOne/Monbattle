class AddDefaultAbilitiesToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :default_abil_socket1, :text, default: "Slap"
    add_column :monsters, :default_abil_socket2, :text, default: "Groin Kick"
  end
end
