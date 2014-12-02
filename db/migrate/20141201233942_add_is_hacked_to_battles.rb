class AddIsHackedToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :is_hacked, :boolean, default: true
  end
end
