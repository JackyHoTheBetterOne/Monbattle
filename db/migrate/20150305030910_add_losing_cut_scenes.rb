class AddLosingCutScenes < ActiveRecord::Migration
  def change
    add_column :cut_scenes, :defeat, :boolean, default: false
  end
end
