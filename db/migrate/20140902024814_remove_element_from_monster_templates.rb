class RemoveElementFromMonsterTemplates < ActiveRecord::Migration
  def change
    remove_column :monster_templates, :element
    remove_column :monster_templates, :job
  end
end
