class CreateGuildMessages < ActiveRecord::Migration
  def change
    create_table :guild_messages do |t|
      t.string :title
      t.text :description
      t.integer :guild_id
      t.integer :summoner_id

      t.timestamps
    end
    add_index :guild_messages, :guild_id
    add_index :guild_messages, :summoner_id
  end
end
