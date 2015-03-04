class ReplaceAvatarOnMonsterSkins < ActiveRecord::Migration
  def change
    remove_attachment :monster_skins, :avatar
    add_column :monster_skins, :avatar, :string, default: "https://s3-us-west-2.amazonaws.com/monbattle/mon_skins/Saphira/saphira_idle.svg"
  end
end
