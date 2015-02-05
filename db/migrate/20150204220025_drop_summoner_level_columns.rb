class DropSummonerLevelColumns < ActiveRecord::Migration
  def change
    remove_column :summoner_levels, :lvl
    remove_column :summoner_levels, :exp_to_nxt_lvl
    remove_column :summoner_levels, :ap
    remove_column :summoner_levels, :monsters_allowed
    add_column :summoner_levels, :level, :integer
    add_column :summoner_levels, :exp_required, :integer
    add_column :summoner_levels, :stamina, :integer
  end
end
