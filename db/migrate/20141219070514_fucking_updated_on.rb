class FuckingUpdatedOn < ActiveRecord::Migration
  def change
    remove_column :battles, :updated_on
    add_column :battles, :finished, :date
  end
end
