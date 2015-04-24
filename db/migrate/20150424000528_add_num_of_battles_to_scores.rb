class AddNumOfBattlesToScores < ActiveRecord::Migration
  def change
    add_column :scores, :num_of_battles, :integer, default: 1
  end
end
