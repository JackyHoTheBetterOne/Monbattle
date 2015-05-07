class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/guild-filler-logo.png"
    add_column :guilds, :aavatar, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/guild-avatar/guild-emblem.png"
  end
end
