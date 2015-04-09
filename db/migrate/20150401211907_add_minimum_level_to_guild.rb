class AddMinimumLevelToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :minimum_level, :integer, default: 0
  end
end
