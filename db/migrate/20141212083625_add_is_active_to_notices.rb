class AddIsActiveToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :is_active, :boolean, default: true
  end
end
