class ChangeSummonerLevelColumn < ActiveRecord::Migration
  def change
    remove_column :summoners, :current_lvl
    add_column :summoners, :level, :integer, default: 0
  end
end
