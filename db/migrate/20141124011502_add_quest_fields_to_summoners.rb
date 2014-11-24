class AddQuestFieldsToSummoners < ActiveRecord::Migration
  def up
    add_column :summoners, :daily_battles, :text, array: true
  end
end
