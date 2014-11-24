class ChangeDefaultForTimeFieldsOnQuests < ActiveRecord::Migration
  def change
    change_column :quests, :end_date, :datetime, :default => Time.now + 6.minutes + 1.year
    change_column :quests, :refresh_date, :datetime, :default => Time.now + 1.year + 6.minutes
  end
end
