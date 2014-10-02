class AddElementTemplateToMonsterTemplates < ActiveRecord::Migration
  def change
    add_reference :monster_templates, :element_template, index: true
  end
end
