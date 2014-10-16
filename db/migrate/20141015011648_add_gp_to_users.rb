class AddGpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gp, :integer
  end
end
