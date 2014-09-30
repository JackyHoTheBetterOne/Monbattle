class AddBattleLevelToBattles < ActiveRecord::Migration
  def change
    add_reference :battles, :battle_level, index: true
  end
end
