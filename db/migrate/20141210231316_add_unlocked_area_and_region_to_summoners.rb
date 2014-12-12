class AddUnlockedAreaAndRegionToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :completed_areas, :text, array: true, default: []
    add_column :summoners, :completed_regions, :text, array: true, default: []
    add_column :regions, :unlocked_by_default, :boolean, default: false
    add_column :areas, :unlocked_by_default, :boolean, default: false
  end
end
