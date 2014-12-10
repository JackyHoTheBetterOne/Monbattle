class AddTotalWinAndLossToSummoner < ActiveRecord::Migration
  def change
    remove_column :users, :rank
    add_column :summoners, :wins, :integer
    add_column :summoners, :losses, :integer  
  end
end
