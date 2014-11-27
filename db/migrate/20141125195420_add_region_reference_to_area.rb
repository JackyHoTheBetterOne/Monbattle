class AddRegionReferenceToArea < ActiveRecord::Migration
  def change
    add_reference :areas, :region, index: true
    add_column :regions, :unlock_id, :integer, index: true
  end
end
