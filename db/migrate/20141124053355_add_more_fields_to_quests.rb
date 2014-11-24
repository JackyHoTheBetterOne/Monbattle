class AddMoreFieldsToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :stat_requirement, :integer
  end
end
