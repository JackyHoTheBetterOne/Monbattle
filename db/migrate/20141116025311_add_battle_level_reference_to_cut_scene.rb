class AddBattleLevelReferenceToCutScene < ActiveRecord::Migration
  def change
    add_reference :cut_scenes, :battle_level, index: true
  end
end
