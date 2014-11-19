class AddDateTimestampsToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :updated_on, :date
  end
end
