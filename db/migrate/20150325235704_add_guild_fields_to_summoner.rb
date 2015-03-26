class AddGuildFieldsToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :led_guild_id, :integer
    add_index :summoners, :led_guild_id
    add_column :summoners, :guild_id, :integer
    add_index :summoners, :guild_id
    add_column :summoners, :sub_led_guild_id, :integer
    add_index :summoners, :sub_led_guild_id
  end
end
