class CreateClassTemplates < ActiveRecord::Migration
  def change
    create_table :class_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
