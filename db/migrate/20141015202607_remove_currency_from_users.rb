class RemoveCurrencyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :currency, :integer
    add_column :users, :mp, :integer
  end
end
