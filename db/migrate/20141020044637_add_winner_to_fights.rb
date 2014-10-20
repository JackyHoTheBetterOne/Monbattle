class AddWinnerToFights < ActiveRecord::Migration
  def change
    add_column :fights, :winner, :boolean, default: false
  end
end
