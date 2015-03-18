class AddGameUnlockToUser < ActiveRecord::Migration
  def change
    add_column :users, :game_unlock, :text, default: ""
  end
end
