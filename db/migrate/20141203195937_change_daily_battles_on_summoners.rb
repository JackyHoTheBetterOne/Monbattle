class ChangeDailyBattlesOnSummoners < ActiveRecord::Migration
  def change
    change_column :summoners, :daily_battles, :text, array: true, default: []
  end
end
