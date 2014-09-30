class RemoveCreatedFromAndIsTemplateFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :created_from_id, :integer
    remove_column :monsters, :is_template, :boolean
  end
end
