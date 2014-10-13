class AddEnemyToParties < ActiveRecord::Migration
  def change
    add_column :parties, :enemy, :text
  end
end
