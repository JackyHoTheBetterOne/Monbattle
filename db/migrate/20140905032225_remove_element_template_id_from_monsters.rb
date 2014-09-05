class RemoveElementTemplateIdFromMonsters < ActiveRecord::Migration
  def change
    remove_reference :monsters, :element_template, index: true
  end
end
