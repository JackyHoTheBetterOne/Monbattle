class RemoveTypeFromMonsterTemplates < ActiveRecord::Migration
  def change
    remove_column :monster_templates, :type, :string
  end
end
