class AddCodeToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :code, :text
    add_index :notifications, :code
  end
end
