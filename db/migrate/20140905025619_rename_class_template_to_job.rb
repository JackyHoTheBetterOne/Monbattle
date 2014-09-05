class RenameClassTemplateToJob < ActiveRecord::Migration
  def change
    rename_table :class_templates, :jobs
  end
end
