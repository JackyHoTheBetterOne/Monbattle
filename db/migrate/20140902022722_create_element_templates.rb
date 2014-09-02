class CreateElementTemplates < ActiveRecord::Migration
  def change
    create_table :element_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
