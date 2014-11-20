class SetDefaultToWinsAndLosses < ActiveRecord::Migration
  def change
    change_column :summoners, :wins, :integer, :default => 0
    change_column :summoners, :losses, :integer, :default => 0
  end
end
