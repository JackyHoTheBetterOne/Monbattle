class CreateUserAvatars < ActiveRecord::Migration
  def change
    create_table :user_avatars do |t|
      t.integer :avatar_id
      t.integer :summoner_id
      t.timestamps
    end
    add_index :user_avatars, :avatar_id
    add_index :user_avatars, :summoner_id
  end
end
