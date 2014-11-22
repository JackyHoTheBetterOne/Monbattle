class AddTypeReferenceToQuests < ActiveRecord::Migration
  def change
    add_reference :quests, :quest_type, index: true
  end
end
