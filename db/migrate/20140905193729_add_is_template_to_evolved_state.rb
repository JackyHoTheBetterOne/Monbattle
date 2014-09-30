class AddIsTemplateToEvolvedState < ActiveRecord::Migration
  def change
    add_column :evolved_states, :is_template, :boolean, default: false
  end
end
