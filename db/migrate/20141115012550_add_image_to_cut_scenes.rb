class AddImageToCutScenes < ActiveRecord::Migration
  def change
    add_attachment :cut_scenes, :image
  end
end
