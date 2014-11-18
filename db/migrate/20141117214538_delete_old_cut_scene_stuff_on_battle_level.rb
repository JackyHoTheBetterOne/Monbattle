class DeleteOldCutSceneStuffOnBattleLevel < ActiveRecord::Migration
  def change
    remove_attachment :battle_levels, :start_cutscene
    remove_attachment :battle_levels, :end_cutscene
  end
end
