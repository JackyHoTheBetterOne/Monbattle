class ChangeBattleLevelIdOnScoresToAreaId < ActiveRecord::Migration
  def change
    remove_column :scores, :battle_level_id
    add_column :scores, :area_id, :integer
    add_index :scores, :area_id
  end
end
