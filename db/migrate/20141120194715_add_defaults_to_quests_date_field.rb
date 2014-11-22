class AddDefaultsToQuestsDateField < ActiveRecord::Migration
  def change
    change_column :quests, :end_date, :datetime, :default => Time.now + 1.year
    change_column :quests, :refresh_date, :datetime, :default => Time.now + 1.year
  end
end
