class DeleteTypeOnQuests < ActiveRecord::Migration
  def change
    remove_column :quests, :type
  end
end
