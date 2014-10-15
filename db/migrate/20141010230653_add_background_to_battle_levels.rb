class AddBackgroundToBattleLevels < ActiveRecord::Migration
  def change
    add_attachment :battle_levels, :background
  end
end
