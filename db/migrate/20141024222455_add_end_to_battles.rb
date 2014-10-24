class AddEndToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :victor, :string
    add_column :battles, :loser, :string
  end
end
