class CreateTargetCategories < ActiveRecord::Migration
  def change
    drop_table :target_categories

    create_table :target_categories do |t|
      t.integer :target_type_id
      t.integer :target_id

      t.timestamps
    end
  end
end
