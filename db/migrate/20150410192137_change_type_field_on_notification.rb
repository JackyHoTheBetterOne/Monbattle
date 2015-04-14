class ChangeTypeFieldOnNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :type
    add_column :notifications, :category, :string
  end
end
