class AddKeywordsToCutScenes < ActiveRecord::Migration
  def change
    add_column :cut_scenes, :keywords, :text
  end
end
