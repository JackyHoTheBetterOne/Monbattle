class AddNameToMonsterTemplates < ActiveRecord::Migration
  def change
    add_column :monster_templates, :name, :string
  end
end
