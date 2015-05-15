class AddFacebookIdToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :facebook_id, :text
  end
end
