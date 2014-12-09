class AddLastUpdateForEnergySummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :last_update_for_energy, :datetime, default: Time.now.localtime
  end
end
