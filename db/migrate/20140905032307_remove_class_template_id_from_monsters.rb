class RemoveClassTemplateIdFromMonsters < ActiveRecord::Migration
  def change
    remove_reference :monsters, :class_template, index: true
  end
end
