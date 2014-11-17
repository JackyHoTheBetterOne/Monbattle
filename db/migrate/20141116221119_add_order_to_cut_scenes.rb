class AddOrderToCutScenes < ActiveRecord::Migration
  def change
    add_column :cut_scenes, :order, :integer
  end
end
