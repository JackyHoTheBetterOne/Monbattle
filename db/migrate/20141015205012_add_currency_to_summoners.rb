class AddCurrencyToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :mp, :integer
    add_column :summoners, :gp, :integer
  end
end
