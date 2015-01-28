class CreateTargetCategories < ActiveRecord::Migration
  def change
    create_table :target_categories do |t|
      t.string :name
      t.timestamps
    end
    add_column :targets, :target_category_id, :integer
  end
end
