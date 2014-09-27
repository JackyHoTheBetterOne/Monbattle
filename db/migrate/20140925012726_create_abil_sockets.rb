class CreateAbilSockets < ActiveRecord::Migration
  def change
    create_table :abil_sockets do |t|
      t.integer :socket_num

      t.timestamps
    end
  end
end
