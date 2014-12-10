class AddSecondsLeftForNextStaminaToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :seconds_left_for_next_energy, :integer
  end
end
