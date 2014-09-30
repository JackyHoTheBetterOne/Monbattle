class RemoveJobAndSkinUrlFromMonsterSkins < ActiveRecord::Migration
  def change
    remove_reference :monster_skins, :job, index: true
    remove_column :monster_skins, :skin_url, :text
  end
end
