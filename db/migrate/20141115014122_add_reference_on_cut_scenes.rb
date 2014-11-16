class AddReferenceOnCutScenes < ActiveRecord::Migration
  def change
    add_reference :cut_scenes, :chapter, index: true
  end
end
