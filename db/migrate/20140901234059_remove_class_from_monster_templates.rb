class RemoveClassFromMonsterTemplates < ActiveRecord::Migration
  def change
    remove_column :monster_templates, :class
  end
end
