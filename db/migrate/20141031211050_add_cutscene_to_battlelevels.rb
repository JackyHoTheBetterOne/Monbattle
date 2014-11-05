class AddCutsceneToBattlelevels < ActiveRecord::Migration
  def change
    add_attachment :battle_levels, :start_cutscene
    add_attachment :battle_levels, :end_cutscene
    add_column :monsters, :stage, :string
  end
end
