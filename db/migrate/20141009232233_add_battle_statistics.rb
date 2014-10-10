class AddBattleStatistics < ActiveRecord::Migration
  def change
    add_column :battles, :round_taken, :integer
    add_column :battles, :time_taken, :interval
  end
end
