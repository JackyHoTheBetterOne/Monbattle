class RemoveTypeFromMonsterSkins < ActiveRecord::Migration
  def change
    remove_column :monster_skins, :type, :string
  end
end
