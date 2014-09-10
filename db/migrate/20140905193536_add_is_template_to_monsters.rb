class AddIsTemplateToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :is_template, :boolean, default: false
  end
end
