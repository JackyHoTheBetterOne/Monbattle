class AddRandomBooleanToBattleLevles < ActiveRecord::Migration
  def change
    add_column :battle_levels, :event, :boolean, default: false
  end
end
