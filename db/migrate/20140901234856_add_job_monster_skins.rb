class AddJobMonsterSkins < ActiveRecord::Migration
  def change
        add_column :monster_skins, :job, :string
  end
end
