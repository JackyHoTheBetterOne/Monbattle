class AddUnlockToArea < ActiveRecord::Migration
  def change
    add_column :areas, :unlock_id, :integer, index: true
  end
end
