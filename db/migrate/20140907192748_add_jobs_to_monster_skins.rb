class AddJobsToMonsterSkins < ActiveRecord::Migration
  def change
    add_reference :monster_skins, :job, index: true
  end
end
