class AddLatestLevelToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :latest_level, :string, default: "AreaA-Stage1"
  end
end
