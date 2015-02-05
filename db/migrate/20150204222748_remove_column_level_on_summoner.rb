class RemoveColumnLevelOnSummoner < ActiveRecord::Migration
  def change
    remove_column :summoners, :level
    remove_column :summoners, :summoner_level_id
    add_column :summoners, :summoner_level_id, :integer, default: 1
  end
end
