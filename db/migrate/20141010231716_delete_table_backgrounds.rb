class DeleteTableBackgrounds < ActiveRecord::Migration
  def change
    drop_table :backgrounds
  end
end
