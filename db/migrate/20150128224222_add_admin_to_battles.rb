class AddAdminToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :admin, :boolean, default: false
    add_column :battles, :session_id, :string
  end
end
