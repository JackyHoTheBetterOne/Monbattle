class ChangeSummonerLevelColumns < ActiveRecord::Migration
  def change
    remove_column :summoner_levels, :exp_required
    add_column :summoner_levels, :exp_required_for_next_level, :integer
  end
end
