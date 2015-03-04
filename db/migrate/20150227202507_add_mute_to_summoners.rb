class AddMuteToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :mute, :boolean, default: false
  end
end
