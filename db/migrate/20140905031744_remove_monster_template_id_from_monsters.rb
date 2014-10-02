class RemoveMonsterTemplateIdFromMonsters < ActiveRecord::Migration
  def change
    remove_reference :monsters, :monster_template, index: true
  end
end
