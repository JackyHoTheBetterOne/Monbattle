class AddDefSocksToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :default_sock3_id, :integer
    add_column :monsters, :default_sock4_id, :integer

  end
end
