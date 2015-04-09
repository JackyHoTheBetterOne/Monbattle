class NoUserNameOnUnlockCodes < ActiveRecord::Migration
  def change
    remove_column :unlock_codes, :user_name
  end
end
