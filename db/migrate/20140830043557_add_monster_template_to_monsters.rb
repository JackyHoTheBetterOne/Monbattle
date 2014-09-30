class AddMonsterTemplateToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :monster_template, index: true
  end
end
