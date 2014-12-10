class AddIconToQuests < ActiveRecord::Migration
  def change
    add_column :quests, :keywords, :text
    add_attachment :quests, :icon
  end
end
