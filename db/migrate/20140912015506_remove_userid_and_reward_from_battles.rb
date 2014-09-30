class RemoveUseridAndRewardFromBattles < ActiveRecord::Migration
  def change
    remove_reference :battles, :user, index: true
    remove_column :battles, :reward, :integer
  end
end
