class AddPlayedLevelsToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :played_levels, :text, array: true, default: []
  end
end
