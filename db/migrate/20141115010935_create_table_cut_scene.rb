class CreateTableCutScene < ActiveRecord::Migration
  def change
    create_table :cut_scenes do |t|
      t.string :name
      t.text :description
      t.boolean :to_start
      t.timestamps
    end
  end
end
