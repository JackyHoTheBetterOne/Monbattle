class AddNameToTarget < ActiveRecord::Migration
  def change
    add_column :targets, :name, :string
  end
end
