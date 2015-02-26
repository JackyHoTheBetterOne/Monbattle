class RemoveTargetCategoryId < ActiveRecord::Migration
  def change
    remove_column :targets, :target_category_id, :integer
  end
end
