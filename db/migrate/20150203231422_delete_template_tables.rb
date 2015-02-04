class DeleteTemplateTables < ActiveRecord::Migration
  def change
    drop_table :monster_templates
  end
end
