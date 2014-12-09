class ChangeSummonerLevel < ActiveRecord::Migration
  def change
    change_column :summoners, :level, :integer, default: 1
  end
end
