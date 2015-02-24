class AddOrderToLeveaddOrderToAreasLevelsRegions < ActiveRecord::Migration
  def change
    add_column :regions, :order, :integer
    add_column :areas, :order, :integer
    add_column :battle_levels, :order, :integer
  end
end
