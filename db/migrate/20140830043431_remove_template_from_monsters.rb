class RemoveTemplateFromMonsters < ActiveRecord::Migration
  def change
    remove_reference :monsters, :template, index: true
  end
end
