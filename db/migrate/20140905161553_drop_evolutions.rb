class DropEvolutions < ActiveRecord::Migration
  def change
    drop_table :evolutions
  end
end
