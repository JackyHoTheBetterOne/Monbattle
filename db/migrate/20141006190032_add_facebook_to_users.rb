class AddFacebookToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    remove_index :users, :email
    add_index :users, :email
  end
end
