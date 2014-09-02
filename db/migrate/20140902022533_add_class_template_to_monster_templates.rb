class AddClassTemplateToMonsterTemplates < ActiveRecord::Migration
  def change
    add_reference :monster_templates, :class_template, index: true
  end
end
