class AddMessageToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :message, :text
  end
end
