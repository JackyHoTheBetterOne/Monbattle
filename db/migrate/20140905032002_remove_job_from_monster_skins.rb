class RemoveJobFromMonsterSkins < ActiveRecord::Migration
  def change
    remove_column :monster_skins, :job, :string
  end
end
