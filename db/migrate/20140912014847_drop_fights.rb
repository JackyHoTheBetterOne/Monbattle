class DropFights < ActiveRecord::Migration
  def change
    drop_table :fights
  end
end
