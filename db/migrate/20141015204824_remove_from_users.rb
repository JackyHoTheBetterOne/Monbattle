class RemoveFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :paid_currency, :integer
    remove_column :users, :mp, :integer
    remove_column :users, :gp, :integer
  end
end
