class RenameElementTemplatesToElements < ActiveRecord::Migration
  def change
    rename_table :element_templates, :elenents
  end
end
