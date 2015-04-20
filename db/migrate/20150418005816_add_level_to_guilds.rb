class AddLevelToGuilds < ActiveRecord::Migration
  def change
    add_column :guilds, :level, :integer, default: 0
  end
end
