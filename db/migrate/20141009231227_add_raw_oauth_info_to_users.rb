class AddRawOauthInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :raw_oauth_info, :text
  end
end
