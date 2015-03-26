class AddUserNameToUnlockCode < ActiveRecord::Migration
  def change
    add_column :unlock_codes, :user_name, :string
  end
end
