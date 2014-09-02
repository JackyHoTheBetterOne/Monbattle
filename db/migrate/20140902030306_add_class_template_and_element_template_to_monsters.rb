class AddClassTemplateAndElementTemplateToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :class_template, index: true
    add_reference :monsters, :element_template, index: true
  end
end
