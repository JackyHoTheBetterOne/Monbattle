class AddGuildToAreas < ActiveRecord::Migration
  def change
    remove_column :battle_levels, :guild
    add_column :areas, :is_guild, :boolean, default: false
  end
end
