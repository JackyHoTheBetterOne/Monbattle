class DeleteBattleBackgrounds < ActiveRecord::Migration
  def change
    remove_attachment :battle_levels, :background
  end
end
