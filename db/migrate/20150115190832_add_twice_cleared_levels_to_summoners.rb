class AddTwiceClearedLevelsToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :cleared_twice_levels, :text, array: true, default: []
    add_column :summoners, :cleared_thrice_levels, :text, array: true, default: []
  end
end
